import 'package:flutter/material.dart';
import 'package:math_escape/app/splash_screen.dart';
import 'app/theme/app_theme.dart';
import 'core/services/service_locator.dart';
import 'constants/app_constants.dart';
import 'core/utils/image_path_validation_tool.dart';

void main() async {
  // 서비스 초기화
  serviceLocator.initialize();
  // QR 정답 데이터 로드
  await serviceLocator.qrAnswerService.loadQrAnswers();
  // 개발 모드에서 이미지 경로 검증 실행
  ImagePathValidationTool.runValidationOnStartup();

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
