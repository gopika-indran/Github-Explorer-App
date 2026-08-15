import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFF0A0C12);
  static const Color surface = Color(0xFF151926);
  static const Color surfaceAlt = Color(0xFF1B2030);
  static const Color fieldFill = Color(0xFF12151F);
  static const Color border = Color(0xFF262B3A);

  static const Color textPrimary = Color(0xFFF3F4F8);
  static const Color textSecondary = Color(0xFF8B93A7);
  static const Color textMuted = Color(0xFF5C6376);

  static const Color accentBlue = Color(0xFF5B7CFA);
  static const Color accentViolet = Color(0xFF8A5CF6);
  static const Color accentSolid = Color(0xFF6C63FF);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentBlue, accentViolet],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color success = Color(0xFF3FB950);
  static const Color danger = Color(0xFFEF5A6F);
  static const Color star = Color(0xFFF3B94E);
  static const Color verified = Color(0xFF4C9AFF);

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accentSolid,
      brightness: Brightness.dark,
      primary: accentSolid,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        hintStyle: const TextStyle(color: textMuted, fontSize: 14.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentSolid, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentSolid,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceAlt,
        side: const BorderSide(color: border),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceAlt,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerColor: border,
    );
  }
}
