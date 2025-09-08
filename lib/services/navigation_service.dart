import 'package:flutter/material.dart';
import '../screens/intro_screen/high_intro_screen.dart';
import '../mission/middle/middle_talk.dart';
import '../mission/elementary_high/elementary_high_talk.dart';
import '../mission/elementary_low/View/elementary_low_intro_view.dart';

/// 네비게이션을 담당하는 서비스
class NavigationService {
  /// 학년별 미션 화면으로 이동
  ///
  /// [context] BuildContext
  /// [level] 학년 레벨 ('고등학교', '중학교', '초등학교 고학년', '초등학교 저학년')
  void navigateToMission(BuildContext context, String level) {
    switch (level) {
      case '고등학교':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HighIntroScreen()),
        );
        break;
      case '중학교':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MiddleIntroScreen()),
        );
        break;
      case '초등학교 고학년':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ElementaryHighTalkScreen()),
        );
        break;
      case '초등학교 저학년':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ElementaryLowIntroView()),
        );
        break;
      default:
        // 알 수 없는 학년 레벨 - 에러 메시지 표시
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('알 수 없는 학년 레벨: $level')));
        break;
    }
  }

  /// QR 스캔 화면으로 이동
  ///
  /// [context] BuildContext
  void navigateToQRScan(BuildContext context) {
    // TODO: QR 스캔 화면으로 이동하는 로직 구현
    // Navigator.push(context, MaterialPageRoute(builder: (_) => const QRScanScreen()));
  }

  /// 이전 화면으로 돌아가기
  ///
  /// [context] BuildContext
  void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// 특정 화면으로 이동 (라우트 이름 사용)
  ///
  /// [context] BuildContext
  /// [routeName] 라우트 이름
  /// [arguments] 전달할 인수
  void navigateToRoute(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }
}
