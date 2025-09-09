import 'package:flutter/material.dart';

class TemporaryElementaryHintDialogue extends StatelessWidget {
  const TemporaryElementaryHintDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 초등 힌트 공통뷰 제작 예정
    return AlertDialog(
      title: const Text("힌트"),
      content: const Text("힌트 뷰는 아직 준비 중입니다."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("닫기"),
        ),
      ],
    );
  }
}
