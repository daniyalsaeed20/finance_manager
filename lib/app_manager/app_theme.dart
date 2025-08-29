// lib/app_manager/theme_config/app_theme.dart

import 'package:flutter/material.dart';

import 'app_theme_builder.dart';
import 'theme_layout_builder.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

enum AppThemeType {
  system,
  light,
  dark,
}

class AppTheme {
  static ThemeData getTheme(AppThemeType type) {
    final layout = getLayout(type);
    final scheme = getColorScheme(type);
    return AppThemeBuilder(colorScheme: scheme, layout: layout).buildTheme();
  }

  static ColorScheme getColorScheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return LightTheme().colorScheme();
      case AppThemeType.dark:
        return DarkTheme().colorScheme();
      default:
        return LightTheme().colorScheme();
    }
  }

  static ThemeLayoutBuilder getLayout(AppThemeType type) {
    switch (type) {
      case AppThemeType.light:
        return LightTheme().layout;
      case AppThemeType.dark:
        return DarkTheme().layout;
      default:
        return LightTheme().layout;
    }
  }
}
