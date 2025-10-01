import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:math_escape/app/splash_screen.dart';
import 'app/theme/app_theme.dart';
import 'core/services/service_locator.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 플랫폼별 시스템 UI 설정
  if (Platform.isAndroid) {
    // 안드로이드: 하단바 숨기기
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );
  } else if (Platform.isIOS) {
    // iOS: 런치 스크린 최적화
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  // 서비스 초기화
  serviceLocator.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      // 키보드 포커싱 해제 메서드
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () {
            final scope = FocusScope.of(context);
            if (!scope.hasPrimaryFocus && scope.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child!,
        );
      },
    );
  }
}
