import 'package:flutter/material.dart';
import 'package:math_escape/App/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 1.0; // 시작부터 보이도록 1.0으로 설정

  @override
  void initState() {
    super.initState();
    // 2.5초 뒤 페이드 아웃 시작
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        opacity = 0.0;
      });
      // 0.7초 후 → MainScreen 이동
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 1000),
        child: Stack(
          children: [
            // 중앙 로고
            Center(
              child: Image.asset(
                'assets/images/common/mainLogo.webp',
                width: 172,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
            // 맨 밑 배경 이미지
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/common/launchBottom.webp',
                height: 268,
                fit: BoxFit.cover, // 좌우 꽉 채우기
              ),
            ),
          ],
        ),
      ),
    );
  }
}