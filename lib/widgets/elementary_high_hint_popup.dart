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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
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
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    hintTitle,
                    style: TextStyle(
                      fontFamily: "SBAggro",
                      fontSize: MediaQuery.of(context).size.width * (16 / 360),
                      fontWeight: FontWeight.w400,
                      color: Color(0xff202020),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hintContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * (16 / 360), height: 1.2),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 56,
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                ),
                child: Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * (16 / 360),
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