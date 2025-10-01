import 'package:flutter/material.dart';

class LayeredCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final Color firstLayerColor;   // 제일 아래
  final Color secondLayerColor;  // 중간
  final Color thirdLayerColor;   // 맨 위 (콘텐츠 박스)

  const LayeredCard({
    super.key,
    required this.child,
    this.height,
    this.firstLayerColor = const Color(0xFF192243),  // 기본값
    this.secondLayerColor = const Color(0xFF3F55A7), // 기본값
    this.thirdLayerColor = Colors.white,             // 기본값
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // 첫 번째 레이어 (고정 높이 배경)
        Container(
          width: width - 80,
          height: 200, // 고정 높이
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: firstLayerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
        ),
        // 두 번째 레이어 (고정 높이 배경)
        Container(
          width: width - 60,
          height: 200, // 고정 높이
          margin: const EdgeInsets.only(top: 18),
          decoration: BoxDecoration(
            color: secondLayerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))
            ],
          ),
        ),
        // 세 번째 레이어 (동적 높이 콘텐츠)
        Container(
          width: width - 40,
          margin: const EdgeInsets.only(top: 31),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: thirdLayerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          child: child, // child 길이에 맞게 늘어남
        ),
      ],
    );
  }
}
