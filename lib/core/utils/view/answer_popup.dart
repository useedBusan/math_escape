import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import 'unified_answer_dialog.dart';

class AnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final StudentGrade grade;
  final VoidCallback onNext;

  const AnswerPopup({
    super.key,
    required this.isCorrect,
    required this.grade,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedAnswerDialog(
      isCorrect: isCorrect,
      onConfirm: onNext,
    );
  }
}
