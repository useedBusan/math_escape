import 'package:flutter/material.dart';

class MiddleTalkDialog extends StatelessWidget {
  const MiddleTalkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.93,
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
                    'assets/images/diary.png',
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "수학자의 비밀 노트를 찾는 여정을\n시작하시겠습니까?",
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: MediaQuery.of(context).size.width * (15 / 360),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff202020),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF3f55a7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // This is the color for the text
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