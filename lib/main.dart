import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_manager/app_manager.dart';
import 'app_manager/app_theme.dart';
import 'app_manager/theme_cubit/theme_cubit.dart';
import 'app_routes.dart';
import 'repositories/auth_repository.dart';
import 'services/isar_service.dart';
import 'services/notification_service.dart';
import 'services/app_lock_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize local DB and notifications
  await IsarService.instance.db;
  await NotificationService.instance.initialize();
  await AppLockManager.instance.enforceLockIfEnabled();

  AppManager.instance;

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        // inside MyApp build method
        return BlocBuilder<ThemeCubit, AppThemeType>(
          builder: (context, appThemeType) {
            final themeData = AppTheme.getTheme(appThemeType);

            return RepositoryProvider(
              create: (context) => AuthRepository(),
              child: MaterialApp.router(
                theme: themeData,
                darkTheme: ThemeData.dark(), // fallback if system theme is dark
                themeMode:
                    ThemeMode.light, // always apply theme directly via `theme`
                routerConfig: appRouter,
              ),
            );
          },
        );
      },
    );
  }
}
