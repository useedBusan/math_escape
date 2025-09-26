import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상 토큰
class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF3F55A7);
  static const Color primaryWhite = Color(0xFFFFFFFF);

  // Background Colors
  static const Color backgroundLightGray = Color(0xFFF5F5F5);
  static const Color backgroundLightBlue = Color(0xFFE8F0FE);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF333333);
  static const Color textTertiary = Color(0xFF000000);
  static const Color textQuaternary = Color(0xFF00000057); // black87

  // Card Colors
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color cardLightGray = Color(0xFFF5F5F5);

  // Shadow Colors
  static const Color shadowBlack = Color(0x1A000000); // black.withOpacity(0.1)

  // Private constructor to prevent instantiation
  AppColors._();
}
