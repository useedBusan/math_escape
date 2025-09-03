//팝업 위젯 분리(정답, 오답 조건)

import 'package:flutter/material.dart';
import 'package:math_escape/Common/Enums/grade_enums.dart';

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
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isCorrect
                  ? 'assets/images/correct.png'
                  : 'assets/images/wrong.png',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),
            Text(
              grade.answerText(isCorrect: isCorrect),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFDDDDDD)),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: TextButton(
                onPressed: onNext,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xffed668a),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
