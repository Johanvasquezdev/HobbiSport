// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme_cubit.dart';
import 'core/services/theme_service.dart';

// Import your router here once v0 UI is integrated
// import 'core/router/app_router.dart';

class HobbiSportApp extends StatelessWidget {
  const HobbiSportApp({super.key});

  ThemeData _buildTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.neon:
        return _neonTheme();
      case AppThemeMode.sunset:
        return _sunsetTheme();
      case AppThemeMode.pop:
        return _popTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'HobbiSport',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(themeMode),
          // routerConfig: appRouter,     // ← wire after v0 UI integration
          home: const Scaffold(
            body: Center(child: Text('HobbiSport — Architecture Ready ✅')),
          ),
        );
      },
    );
  }

  // ── NEON theme: deep violet + electric green ───────────────
  ThemeData _neonTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C3AED),
          secondary: Color(0xFF22C55E),
          surface: Color(0xFF1A1A24),
          onSurface: Color(0xFFCBCBD4),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
      );

  // ── SUNSET theme: amber + rose ─────────────────────────────
  ThemeData _sunsetTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF59E0B),
          secondary: Color(0xFFF43F5E),
          surface: Color(0xFF241A10),
          onSurface: Color(0xFFD4C4B8),
        ),
        scaffoldBackgroundColor: const Color(0xFF1A0F0A),
      );

  // ── POP theme: cyan + lime ─────────────────────────────────
  ThemeData _popTheme() => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF06B6D4),
          secondary: Color(0xFF84CC16),
          surface: Color(0xFF0D1A20),
          onSurface: Color(0xFFB8D4D8),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A1015),
      );
}
