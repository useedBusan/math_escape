import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';


enum StudentGrade { elementaryLow, elementaryHigh, middle, high }

extension GradeTheme on StudentGrade {

  // 메인 컬러 (상단바)
  Color get mainColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return CustomPink.s500;
      case StudentGrade.middle:
      case StudentGrade.high:
        return CustomBlue.s500;
    }
  }

  // 말풍선 테두리 색상
  Color get bubbleBorderColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return CustomPink.s700;
      case StudentGrade.middle:
      case StudentGrade.high:
        return CustomBlue.s800;
    }
  }

  // 스피커 이름표 배경 색상
  Color get speakerLabelColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return CustomPink.s600;
      case StudentGrade.middle:
      case StudentGrade.high:
        return CustomBlue.s500;
    }
  }

  // 그라데이션 색상 (배경 오버레이)
  List<Color> get gradientColors {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return [CustomBlue.s900.withOpacity(0.75), CustomBlue.s800.withOpacity(0.5)];
      case StudentGrade.middle:
      case StudentGrade.high:
        return [CustomBlue.s900.withOpacity(0.75), CustomBlue.s800.withOpacity(0.5)];
    }
  }

  // 배너 이미지
  String? get bannerImg {
    switch (this) {
      case StudentGrade.elementaryLow:
        return 'assets/images/elementary_low/bannerElemLow.png';
      case StudentGrade.elementaryHigh:
        return 'assets/images/elementary_high/bannerElemHigh.png';
      case StudentGrade.middle:
        return '';
      case StudentGrade.high:
        return '';
    }
  }

  String answerText({required bool isCorrect}) {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return isCorrect
            ? '정답이야! 이야! 수학 천재 등장!\n보물에 한 걸음 더 가까워졌어!'
            : '아쉽지만 오답이야. 조금 헷갈렸지?\n다시 한 번 생각해볼까?';
      case StudentGrade.middle:
      case StudentGrade.high:
        return isCorrect
            ? '정답입니다!\n조금만 더 풀면 탈출할 수 있어요!'
            : '오답입니다.\n다시 한 번 생각해 볼까요?';
    }
  }
}