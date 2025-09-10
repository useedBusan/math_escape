import 'package:flutter/material.dart';

/// 공통 위젯에서 사용하는 스타일 상수들
class WidgetConstants {
  // 색상 상수
  static const Color correctColor = Color(0xff08BBAC);
  static const Color wrongColor = Color(0xffD95252);
  static const Color primaryColor = Color(0xFF3F55A7);
  static const Color secondaryColor = Color(0xffed668a);
  static const Color backgroundColor = Color(0xffffffff);
  static const Color textColor = Color(0xff202020);
  static const Color dividerColor = Color(0xFFDDDDDD);

  // 크기 상수
  static const double dialogWidth = 0.93;
  static const double iconSize = 80.0;
  static const double buttonHeight = 56.0;
  static const double borderRadius = 8.0;
  static const double padding = 24.0;

  // 폰트 크기 상수
  static const double titleFontSize = 16.0;
  static const double contentFontSize = 16.0;
  static const double buttonFontSize = 16.0;

  // 애니메이션 상수
  static const Duration animationDuration = Duration(milliseconds: 300);

  // 텍스트 스타일
  static TextStyle get titleTextStyle => const TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static TextStyle get contentTextStyle =>
      const TextStyle(fontSize: contentFontSize, color: textColor);

  static TextStyle get buttonTextStyle =>
      const TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold);

  // 색상별 텍스트 스타일
  static TextStyle get correctTextStyle => const TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: correctColor,
  );

  static TextStyle get wrongTextStyle => const TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
    color: wrongColor,
  );
}
