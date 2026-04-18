import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { neon, sunset, pop }

abstract class ThemeService {
  Future<AppThemeMode> getSavedTheme();
  Future<void> saveTheme(AppThemeMode mode);
}

class ThemeServiceImpl implements ThemeService {
  ThemeServiceImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _themeKey = 'app_theme_mode';

  @override
  Future<AppThemeMode> getSavedTheme() async {
    final value = _prefs.getString(_themeKey);
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.neon,
    );
  }

  @override
  Future<void> saveTheme(AppThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
  }
}
