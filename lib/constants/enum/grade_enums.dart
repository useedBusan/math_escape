import 'package:flutter/material.dart';


enum StudentGrade { elementaryLow, elementaryHigh, middle, high }

extension GradeTheme on StudentGrade {

  // 메인 컬러 (상단바)
  Color get mainColor {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return const Color(0xffD95276);
      case StudentGrade.middle:
      case StudentGrade.high:
        return const Color(0xff3F55A7);
    }
  }

  // 배너 이미지 - 고등은 없음
  String? get bannerImg {
    switch (this) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return 'assets/images/elementary_banner.png';
      case StudentGrade.middle:
        return 'assets/images/middle_banner.png';
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