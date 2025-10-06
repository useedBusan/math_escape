import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class PlatformUtils {
  /// 플랫폼별 스토어 링크 열기
  static Future<void> openStoreLink() async {
    String url;
    
    if (Platform.isAndroid) {
      // 안드로이드 플레이스토어 링크
      url = 'https://play.google.com/store/apps/details?id=com.career_recommendation';
    } else if (Platform.isIOS) {
      // iOS 앱스토어 링크
      url = 'https://apps.apple.com/app/id1668027175';
    } else {
      // 웹이나 다른 플랫폼의 경우 기본 링크
      url = 'https://play.google.com/store/apps/details?id=com.career_recommendation';
    }
    
    await _launchUrl(url);
  }
  
  /// URL 실행
  static Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}