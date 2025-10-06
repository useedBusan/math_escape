// 사용하지 않는 파일 - 예시 파일
/*
import 'package:flutter/material.dart';
import 'lottie_animation_widget.dart';

/// 로티 애니메이션 사용 예시
class LottieExample extends StatelessWidget {
  const LottieExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로티 애니메이션 예시'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 기본 로티 애니메이션
            const LottieAnimationWidget(
              assetPath: 'assets/animations/example.json',
              width: 200,
              height: 200,
            ),
            
            const SizedBox(height: 20),
            
            // 반복하지 않는 애니메이션
            const LottieAnimationWidget(
              assetPath: 'assets/animations/one_time.json',
              width: 150,
              height: 150,
              repeat: false,
            ),
            
            const SizedBox(height: 20),
            
            // 컨트롤러가 있는 애니메이션
            LottieAnimationController(
              assetPath: 'assets/animations/controllable.json',
              width: 100,
              height: 100,
              onLoaded: () {
              },
              onCompleted: () {
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
