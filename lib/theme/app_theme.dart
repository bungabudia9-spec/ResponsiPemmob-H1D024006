import 'package:flutter/material.dart';

class AppTheme {
  // Palet warna acuan desain:
  static const Color navyBlue = Color(0xFF102D59);
  static const Color deepNavy = Color(0xFF0B2145);
  static const Color skyBlue = Color(0xFF79BDF2);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color backgroundColor = Color(0xFFF4F7FC);
  static const Color textPrimary = Color(0xFF102D59);
  static const Color textSecondary = Color(0xFF64748B);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: navyBlue,
        primary: navyBlue,
        secondary: skyBlue,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: navyBlue.withValues(alpha: 0.08),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 15, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 13, color: textSecondary),
        bodySmall: TextStyle(fontSize: 11, color: textSecondary),
      ),
    );
  }
}
