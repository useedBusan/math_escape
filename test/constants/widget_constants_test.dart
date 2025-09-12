import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/constants/widget_constants.dart';

void main() {
  group('WidgetConstants Tests', () {
    test('색상 상수들이 올바르게 정의되어 있는지 테스트', () {
      expect(WidgetConstants.correctColor, const Color(0xff08BBAC));
      expect(WidgetConstants.wrongColor, const Color(0xffD95252));
      expect(WidgetConstants.primaryColor, const Color(0xFF3F55A7));
      expect(WidgetConstants.secondaryColor, const Color(0xffed668a));
      expect(WidgetConstants.backgroundColor, const Color(0xffffffff));
      expect(WidgetConstants.textColor, const Color(0xff202020));
      expect(WidgetConstants.dividerColor, const Color(0xFFDDDDDD));
    });

    test('크기 상수들이 올바르게 정의되어 있는지 테스트', () {
      expect(WidgetConstants.dialogWidth, 0.93);
      expect(WidgetConstants.iconSize, 80.0);
      expect(WidgetConstants.buttonHeight, 56.0);
      expect(WidgetConstants.borderRadius, 8.0);
      expect(WidgetConstants.padding, 24.0);
    });

    test('폰트 크기 상수들이 올바르게 정의되어 있는지 테스트', () {
      expect(WidgetConstants.titleFontSize, 16.0);
      expect(WidgetConstants.contentFontSize, 16.0);
      expect(WidgetConstants.buttonFontSize, 16.0);
    });

    test('애니메이션 상수가 올바르게 정의되어 있는지 테스트', () {
      expect(
        WidgetConstants.animationDuration,
        const Duration(milliseconds: 300),
      );
    });

    test('텍스트 스타일이 올바르게 생성되는지 테스트', () {
      final titleStyle = WidgetConstants.titleTextStyle;
      expect(titleStyle.fontSize, 16.0);
      expect(titleStyle.fontWeight, FontWeight.w400);
      expect(titleStyle.color, const Color(0xff202020));

      final contentStyle = WidgetConstants.contentTextStyle;
      expect(contentStyle.fontSize, 16.0);
      expect(contentStyle.color, const Color(0xff202020));

      final buttonStyle = WidgetConstants.buttonTextStyle;
      expect(buttonStyle.fontSize, 16.0);
      expect(buttonStyle.fontWeight, FontWeight.bold);
    });

    test('색상별 텍스트 스타일이 올바르게 생성되는지 테스트', () {
      final correctStyle = WidgetConstants.correctTextStyle;
      expect(correctStyle.fontSize, 16.0);
      expect(correctStyle.fontWeight, FontWeight.bold);
      expect(correctStyle.color, const Color(0xff08BBAC));

      final wrongStyle = WidgetConstants.wrongTextStyle;
      expect(wrongStyle.fontSize, 16.0);
      expect(wrongStyle.fontWeight, FontWeight.bold);
      expect(wrongStyle.color, const Color(0xffD95252));
    });
  });
}
