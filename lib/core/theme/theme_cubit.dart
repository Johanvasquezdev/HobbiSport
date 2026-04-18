import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/theme_service.dart';

class ThemeCubit extends Cubit<AppThemeMode> {
  ThemeCubit(this._themeService) : super(AppThemeMode.neon);

  final ThemeService _themeService;

  Future<void> loadSavedTheme() async {
    final mode = await _themeService.getSavedTheme();
    emit(mode);
  }

  Future<void> setTheme(AppThemeMode mode) async {
    await _themeService.saveTheme(mode);
    emit(mode);
  }
}
