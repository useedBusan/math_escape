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
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.93,
        decoration: BoxDecoration(
          color: const Color(0xffffffff), // 원하는 색상으로 변경 (예: 연한 파랑)
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 24.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/hint_puri.png',
                    width: 88,
                    height: 88,
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
                ],
              ),
            ),
            Container(
              width: double.infinity,
               decoration: const BoxDecoration(
                color: Color(0xFFD95276),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                 style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: const Size.fromHeight(52),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                ),
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