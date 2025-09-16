import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';


enum AnswerKind { correct, incorrect }

@immutable
class AnswerModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color buttonColor;

  const AnswerModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.buttonColor,
  });
}

AnswerModel themeOf({
  required bool isCorrect,
  required StudentGrade grade,
}) {
  final icon = isCorrect ? Icons.check_circle : Icons.cancel;
  final accentColor = isCorrect ? AppColors.correct : AppColors.incorrect;

  switch (grade) {
    case StudentGrade.elementaryLow:
    case StudentGrade.elementaryHigh:
      return AnswerModel(
        icon: icon,
        title: isCorrect
            ? '정답이야! 수학 천재 등장!'
            : '아쉽지만 오답이야. 조금 헷갈렸지?',
        subtitle: isCorrect
            ? '보물에 한 걸음 더 가까워졌어!'
            : '다시 한 번 생각해볼까?',
        accentColor: accentColor,
        buttonColor: CustomPink.s500,
      );

    case StudentGrade.middle:
    case StudentGrade.high:
      return AnswerModel(
        icon: icon,
        title: isCorrect ? '정답입니다!' : '오답입니다.',
        subtitle: isCorrect
            ? '좋아요, 다음 문제로 넘어가볼까요?'
            : '다시 한 번 생각해 볼까요?',
        accentColor: accentColor,
        buttonColor: CustomBlue.s500,
      );
  }
}