import 'package:flutter/material.dart';

/// 컬러셋 외 사용되는 색상
class AppColors {
  // Text
  static const head = Color(0xFF202020);
  static const body = Color(0xFF333333);

  // States
  static const correct   = Color(0xFF08BBAC);
  static const incorrect = Color(0xFFD95252);
}

/// 디자이너님께서 정리해주신 컬러셋
class CustomPink {
  static const s50 = Color(0xFFFFEDFA);
  static const s100 = Color(0xFFFFCFDC);
  static const s200 = Color(0xFFFFAEC3);
  static const s300 = Color(0xFFFF8DAB);
  static const s400 = Color(0xFFFB6A91);
  static const s500 = Color(0xFFD95276);
  static const s600 = Color(0xFFB73D5D);
  static const s700 = Color(0xFF952B47);
  static const s800 = Color(0xFF731C33);
  static const s900 = Color(0xFF511021);

  static const swatch = <int, Color>{
    50: s50, 100: s100, 200: s200, 300: s300, 400: s400, 500: s500,
    600: s600, 700: s700, 800: s800, 900: s900,
  };
}

class CustomBlue {
  static const s50 = Color(0xFFDEE5FF);
  static const s100 = Color(0xFFD9DDED);
  static const s200 = Color(0xFFB2BBDC);
  static const s300 = Color(0xFF8C99CA);
  static const s400 = Color(0xFF6577B9);
  static const s500 = Color(0xFF3F55A7);
  static const s600 = Color(0xFF324486);
  static const s700 = Color(0xFF263364);
  static const s800 = Color(0xFF192243);
  static const s900 = Color(0xFF0D1121);

  static const swatch = <int, Color>{
    50: s50, 100: s100, 200: s200, 300: s300, 400: s400, 500: s500,
    600: s600, 700: s700, 800: s800, 900: s900,
  };
}

class CustomGray {
  static const lightGray = Color(0xFFDCDCDC);
  static const darkGray = Color(0xFFAAAAAA);
}