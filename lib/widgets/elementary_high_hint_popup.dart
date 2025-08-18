import 'package:flutter/material.dart';

class HintDialog extends StatelessWidget {
  final String hintTitle;
  final String hintContent;

  const HintDialog({
    Key? key,
    required this.hintTitle,
    required this.hintContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color(0xffffffff), // 원하는 색상으로 변경 (예: 연한 파랑)
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/hint_puri.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 18),
            Text(
              hintTitle,
              style: const TextStyle(
                fontFamily: "SBAggro",
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xff202020),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hintContent,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD95276),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}