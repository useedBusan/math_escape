import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'app/splash_screen.dart';
import 'app/theme/app_theme.dart';
import 'core/services/service_locator.dart';
import 'constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 가로모드 방지(세로모드 지원)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // 플랫폼별 시스템 UI 설정
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  } else if (Platform.isIOS) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  
  // 서비스 초기화
  serviceLocator.initialize();

  // 전역 BGM 시작
  serviceLocator.audioService
      .playBgm('assets/audio/bgm/mathEscapeBGM.mp3')
      .catchError((e) => print('BGM 로드 실패: $e'));

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
