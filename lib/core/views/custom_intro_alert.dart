import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../extensions/string_extension.dart';

class CustomIntroAlert extends StatelessWidget {
  final StudentGrade grade;
  final String buttonText;
  final VoidCallback onConfirm;

  const CustomIntroAlert({
    super.key,
    this.buttonText = '확인',
    required this.onConfirm,
    required this.grade
  });

  String _mainImage() {
    switch (grade) {
      case StudentGrade.elementaryLow:
        return '';
      case StudentGrade.middle:
        return 'assets/images/middle/middleDiary.webp';
      default:
        return '';
    }
  }

  Color _mainColor() {
    switch(grade) {
      case StudentGrade.elementaryLow:
        return const Color(0xffD95276);
      case StudentGrade.middle:
        return const Color(0xff3F55A7);
      default:
        return Colors.white;
    }
  }

  String _mainText() {
    switch(grade) {
      case StudentGrade.elementaryLow:
        return '수학자가 남긴 보물을 찾는 탐험을 시작하시겠습니까?';
      case StudentGrade.middle:
        return '수학자의 비밀 노트를 찾는 여정을 시작하시겠습니까?';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 24.0),
              child: Column(
                children: [
                  Image.asset(
                    _mainImage(),
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 18),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff202020),
                      ),
                      children: _mainText().toStyledSpans(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: _mainColor(),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: TextButton(
                onPressed: onConfirm,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}