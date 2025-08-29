// theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_theme.dart';

class ThemeCubit extends Cubit<AppThemeType> {
  static const String _themePrefKey = 'selected_app_theme';

  ThemeCubit() : super(AppThemeType.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themePrefKey) ?? AppThemeType.system.index;
    emit(AppThemeType.values[index]);
  }

  Future<void> setTheme(AppThemeType theme) async {
    emit(theme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, theme.index);
  }
}
