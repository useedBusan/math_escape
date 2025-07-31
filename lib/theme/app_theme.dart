import 'package:flutter/material.dart';
import 'package:math_escape/constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      fontFamily: AppConstants.fontFamily,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.blueAccent,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.blue,
        ),
      ),
    );
  }
} 