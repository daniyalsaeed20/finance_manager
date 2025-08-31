buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Workaround for plugins missing AGP 8 namespace (e.g., isar_flutter_libs)
// This assigns a safe namespace to the specific library subproject.
plugins.withId("com.android.application") {}
subprojects {
    afterEvaluate {
        if (name.contains("isar_flutter_libs") && plugins.hasPlugin("com.android.library")) {
            val ext = extensions.findByName("android")
            if (ext is com.android.build.gradle.LibraryExtension) {
                if (ext.namespace == null || ext.namespace!!.isEmpty()) {
                    // Match the manifest package to avoid AGP 8 failure
                    ext.namespace = "dev.isar.isar_flutter_libs"
                    println("Applied namespace to subproject $name: ${ext.namespace}")
                }
                
                // Add additional configuration to fix resource linking issues
                ext.buildTypes {
                    getByName("release") {
                        isMinifyEnabled = false
                        isShrinkResources = false
                    }
                }
                
                ext.lint {
                    disable += "MissingTranslation"
                    checkReleaseBuilds = false
                }
                
                // Add packaging options to fix resource conflicts
                ext.packagingOptions {
                    resources {
                        excludes += "/META-INF/{AL2.0,LGPL2.1}"
                        pickFirsts += "**/libc++_shared.so"
                    }
                }
                
                // Force specific compile options to avoid resource conflicts
                ext.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }
                
                // Add specific resource filtering
                ext.androidResources {
                    ignoreAssetsPattern = "!.svn:!.git:!.ds_store:!*.scc:.*:!CVS:!thumbs.db:!picasa.ini:!*~"
                }
                
                // Force specific SDK versions for the subproject
                ext.compileSdk = 34
                ext.defaultConfig {
                    targetSdk = 34
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
