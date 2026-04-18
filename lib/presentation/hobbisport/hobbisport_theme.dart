import 'package:flutter/material.dart';

enum HobbiSportPalette { neon, sunset, pop }

extension HobbiSportPaletteX on HobbiSportPalette {
  String get label {
    switch (this) {
      case HobbiSportPalette.neon:
        return 'Neon';
      case HobbiSportPalette.sunset:
        return 'Sunset';
      case HobbiSportPalette.pop:
        return 'Pop';
    }
  }

  String get description {
    switch (this) {
      case HobbiSportPalette.neon:
        return 'Coral + Cyan vibes';
      case HobbiSportPalette.sunset:
        return 'Orange + Purple warmth';
      case HobbiSportPalette.pop:
        return 'Lime + Pink energy';
    }
  }

  Color get primarySwatchColor {
    switch (this) {
      case HobbiSportPalette.neon:
        return const Color(0xFFFF6B6B);
      case HobbiSportPalette.sunset:
        return const Color(0xFFFF9F43);
      case HobbiSportPalette.pop:
        return const Color(0xFFA8E6CF);
    }
  }

  Color get secondarySwatchColor {
    switch (this) {
      case HobbiSportPalette.neon:
        return const Color(0xFF4ECDC4);
      case HobbiSportPalette.sunset:
        return const Color(0xFFA55EEA);
      case HobbiSportPalette.pop:
        return const Color(0xFFFF8FAB);
    }
  }
}

ThemeData buildHobbiSportTheme(HobbiSportPalette palette) {
  const background = Color(0xFF161820);
  const surface = Color(0xFF1F2330);
  const surfaceHigh = Color(0xFF272C3B);
  const muted = Color(0xFF2D3344);
  const foreground = Color(0xFFF4F5F7);
  const mutedForeground = Color(0xFF9EA4B5);
  const destructive = Color(0xFFFF5D5D);

  final scheme = ColorScheme.dark(
    primary: palette.primarySwatchColor,
    onPrimary: const Color(0xFF101218),
    secondary: palette.secondarySwatchColor,
    onSecondary: const Color(0xFF101218),
    tertiary: palette.secondarySwatchColor,
    onTertiary: const Color(0xFF101218),
    error: destructive,
    onError: Colors.white,
    surface: surface,
    onSurface: foreground,
    surfaceContainer: muted,
    surfaceContainerHigh: surfaceHigh,
    outline: const Color(0xFF3A4052),
    outlineVariant: const Color(0xFF31384A),
    scrim: Colors.black,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: foreground,
          displayColor: foreground,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
      ),
    ),
    iconTheme: const IconThemeData(color: foreground),
    dividerColor: scheme.outlineVariant.withValues(alpha: 0.55),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: const CircleBorder(),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surface.withValues(alpha: 0.95),
      selectedItemColor: scheme.primary,
      unselectedItemColor: mutedForeground,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide.none,
      backgroundColor: muted.withValues(alpha: 0.7),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary),
      ),
    ),
  );
}

