import 'package:cewrrs/presentation/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Appcolors.border,

    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 6, 176, 255),
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Appcolors.textDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Appcolors.fieldFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Appcolors.border),
      ),
      hintStyle: TextStyle(color: Appcolors.textLight),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Appcolors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF121212),
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 6, 176, 255),
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Appcolors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
