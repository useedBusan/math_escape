//스플래시 로딩 화면

import 'package:flutter/material.dart';
import 'package:math_escape/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0.0;

  @override
  void initState() {  //_SplashScreenState 클래스가 생성시 initState() 메서드가 자동 호출
    super.initState();
    // 1초 후 페이드 인
    Future.delayed(const Duration(seconds: 1), () { //앱 시작후 1초 뒤 setState()실행
      setState(() {
        opacity = 1.0;  //opacity변수 값 변경
      });
      // 2초 후(페이드 인 끝) → 페이드 아웃 시작
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          opacity = 0.0;
        });
        // 0.7초 후(페이드 아웃 끝) → MainScreen 이동
        Future.delayed(const Duration(milliseconds: 700), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경색
      body: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 700),
        child: Stack(
          children: [
            // 로고: 화면 중앙
            Center(
              child: Image.asset(
                'assets/images/logo_icon.png', // 로고 이미지 경로
                width: 150,
                height: 150,
              ),
            ),
            // 이어폰 안내: 화면 하단
            Positioned(
              left: 0,
              right: 0,
              bottom: 80, // 하단 여백 조절
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.headphones, // 이어폰 아이콘
                      size: 64,
                      color: Colors.lightBlue,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '원활한 체험을 위해\n이어폰 착용을 권장드립니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
