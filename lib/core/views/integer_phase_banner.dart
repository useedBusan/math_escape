import 'package:flutter/material.dart';
import '../extensions/string_extension.dart';
import '../utils/integer_phase_utils.dart';

class IntegerPhaseBanner extends StatelessWidget {
  final int questionNumber;
  final String furiImagePath;
  final double fontSize;

  const IntegerPhaseBanner({
    super.key,
    required this.questionNumber,
    required this.furiImagePath,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final phaseText = IntegerPhaseUtils.getPhaseText(
      IntegerPhaseUtils.getPhaseFromQuestionNumber(questionNumber)
    );

    return Row(
      children: [
        // 퓨리 이미지 공간 (왼쪽)
        SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: Image.asset(
              furiImagePath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 텍스트 (오른쪽)
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: "Pretendard",
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                height: 1.3
              ),
              children: phaseText.toStyledSpans(fontSize: fontSize),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
