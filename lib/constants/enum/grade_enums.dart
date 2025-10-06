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
        return [CustomBlue.s900.withValues(alpha: 0.75), CustomBlue.s800.withValues(alpha: 0.5)];
      case StudentGrade.middle:
      case StudentGrade.high:
        return [CustomBlue.s900.withValues(alpha: 0.75), CustomBlue.s800.withValues(alpha: 0.5)];
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

  // 메인 화면 카드 정보
  String get title {
    switch (this) {
      case StudentGrade.elementaryLow:
        return '미션! 수학자의\n수첩을 따라서';
      case StudentGrade.elementaryHigh:
        return '미션! 수사모의\n보물을 찾아서';
      case StudentGrade.middle:
        return '수학자의 비밀\n노트를 찾아라!';
      case StudentGrade.high:
        return '역설, 혹은\n모호함';
    }
  }

  String get subtitle {
    switch (this) {
      case StudentGrade.elementaryLow:
        return '초등 저학년 추천';
      case StudentGrade.elementaryHigh:
        return '초등 고학년 추천';
      case StudentGrade.middle:
        return '중학생 추천';
      case StudentGrade.high:
        return '고등학생 추천';
    }
  }

  String get imagePath {
    switch (this) {
      case StudentGrade.elementaryLow:
        return 'assets/images/common/mainElemLow.png';
      case StudentGrade.elementaryHigh:
        return 'assets/images/common/mainElemHigh.png';
      case StudentGrade.middle:
        return 'assets/images/common/mainMiddle.png';
      case StudentGrade.high:
        return 'assets/images/common/mainHigh.png';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return CustomPink.s50;
      case StudentGrade.middle:
      case StudentGrade.high:
        return CustomBlue.s50;
    }
  }

  Color get textColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return CustomPink.s500;
      case StudentGrade.middle:
      case StudentGrade.high:
        return CustomBlue.s500;
    }
  }

  String get levelName {
    switch (this) {
      case StudentGrade.elementaryLow:
        return '초등학교 저학년';
      case StudentGrade.elementaryHigh:
        return '초등학교 고학년';
      case StudentGrade.middle:
        return '중학교';
      case StudentGrade.high:
        return '고등학교';
    }
  }
}