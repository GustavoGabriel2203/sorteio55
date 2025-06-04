import 'package:flutter/material.dart';
import 'package:sorteio_55_tech/config/theme_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.afinzPrimaryDark,
        primaryColor: AppColors.afinzAccent,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.whiteText),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.afinzAccent,
            foregroundColor: AppColors.whiteText,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: AppColors.inputFill,
        ),
      );
}
