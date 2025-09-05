import 'package:url_launcher/url_launcher.dart' as launcher;

/// URL 실행을 담당하는 서비스
class UrlLauncherService {
  /// URL을 외부 브라우저에서 실행
  /// 
  /// [url] 실행할 URL 문자열
  /// 
  /// Returns [bool] 실행 성공 여부
  Future<bool> launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // URL 실행 중 에러 발생
      return false;
    }
  }

  /// URL이 유효한지 확인
  /// 
  /// [uri] 확인할 URI 객체
  /// 
  /// Returns [bool] 유효한 URL인지 여부
  Future<bool> canLaunchUrl(Uri uri) async {
    try {
      return await launcher.canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}
