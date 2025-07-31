//팝업 위젯 분리(정답, 오답 조건)

import 'package:flutter/material.dart';

class AnswerPopup extends StatelessWidget {
  final bool isCorrect;

  const AnswerPopup({super.key, required this.isCorrect});

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
              isCorrect ? 'assets/images/correct.png' : 'assets/images/wrong.png',
              width: 64,
              height: 64,
            ),
            const SizedBox(height: 16),
            Text(
              isCorrect ? '정답입니다!' : '오답입니다.',
              style: TextStyle(
                color: isCorrect ? Colors.cyan : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect
                  ? '조금만 더 풀면 탈출할 수 있어요!'
                  : '다시 한번 생각해 볼까요?',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}