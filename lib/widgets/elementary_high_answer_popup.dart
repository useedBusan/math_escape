// lib/widgets/elementary_high_answer_popup.dart
import 'package:flutter/material.dart';

class AnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onNext;

  const AnswerPopup({
    super.key,
    required this.isCorrect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              size: 72,
              color: isCorrect ? Colors.cyan : Colors.red,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  TextSpan(
                    text: isCorrect ? '정답' : '오답',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCorrect ? Colors.cyan : Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: isCorrect
                        ? '이야! 수학 천재 등장!'
                        : '이야. 조금 헷갈렸지?',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect
                  ? '보물에 한 걸음 더 가까워졌어!'
                  : '다시 한 번 생각해볼까?',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: onNext,
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xffed668a),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(isCorrect ? '다음' : '확인'),
            ),
          ],
        ),
      ),
    );
  }
}
