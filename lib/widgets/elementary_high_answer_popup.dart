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
        width: MediaQuery.of(context).size.width * 0.93,
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    size: 80,
                    color: isCorrect ? const Color(0xff08BBAC) : const Color(0xffD95252),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * (16 / 360), color: const Color(0xff202020)),
                      children: [
                        TextSpan(
                          text: isCorrect ? '정답' : '오답',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCorrect ? const Color(0xff08BBAC) : const Color(0xffD95252),
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
                  const SizedBox(height: 2),
                  Text(
                    isCorrect
                        ? '보물에 한 걸음 더 가까워졌어!'
                        : '다시 한 번 생각해볼까?',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * (16 / 360)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
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
                child: Text(isCorrect ? '다음' : '확인',
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * (16 / 360)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
