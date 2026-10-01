import 'package:flutter/material.dart';

class AppTheme {
  static const saffron = Color(0xFFB8672E);
  static const _ink = Color(0xFF2B2622);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: saffron,
      brightness: Brightness.light,
      surface: const Color(0xFFFAF6F0),
    );
    return _build(scheme);
  }

  static ThemeData dark() => _build(ColorScheme.fromSeed(
        seedColor: saffron,
        brightness: Brightness.dark,
      ));

  static ThemeData _build(ColorScheme s) => ThemeData(
        useMaterial3: true,
        colorScheme: s,
        scaffoldBackgroundColor: s.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: s.surface,
          foregroundColor: s.brightness == Brightness.light ? _ink : null,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: s.surfaceContainerHighest.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: s.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
      );
}
