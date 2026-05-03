import 'package:flutter/material.dart';

class SCNTheme {
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4FC3F7);
  static const Color bgLight = Color(0xFFF8FBFF);
  static const Color textPrimary = Color(0xFF1E1E2C);
  static const Color textSecondary = Color(0xFF6E6E8A);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bgLight,
    fontFamily: 'Poppins',

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
    ),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
      ),
    ),
  );
}