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
  if (Platform.isIOS) {
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

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      // iOS와 Android 모두 백그라운드 진입 시
        serviceLocator.audioService.goToBackground();
        break;
      case AppLifecycleState.resumed:
      // 다시 포그라운드로 돌아올 때
        serviceLocator.audioService.backToApp();
        break;
      case AppLifecycleState.inactive:
      // Android에서 전환 중일 때도 일시정지하려면 여기 추가
        break;
      default:
        break;
    }
  }

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
