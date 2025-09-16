import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Core/utils/view/qr_scan_screen.dart';
import '../../Feature/elementary_high/view/elementary_high_talk.dart';
import '../../Feature/elementary_low/View/elementary_low_intro_view.dart';
import '../../Feature/middle/view/middle_talk.dart';
import '../../feature/high/view/high_intro_screen.dart';

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
  /// [onQRScanned] QR 스캔 완료 시 콜백 함수
  Future<void> navigateToQRScan(
    BuildContext context, {
    Function(String)? onQRScanned,
  }) async {
    // 카메라 권한 요청
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // QR 스캔 화면으로 이동
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QRScanScreen()),
      );

      if (result != null && result is String && onQRScanned != null) {
        onQRScanned(result);
      }
    } else {
      // 권한 거부 시 안내 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
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
