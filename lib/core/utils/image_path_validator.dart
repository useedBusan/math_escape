import 'package:flutter/foundation.dart';

/// 이미지 경로 검증 및 관리를 담당하는 유틸리티 클래스
class ImagePathValidator {
  /// 유효한 이미지 경로 패턴들
  static const Set<String> validPathPatterns = {
    'assets/images/common/',
    'assets/images/elementary_low/',
    'assets/images/elementary_high/',
    'assets/images/middle/',
    'assets/images/high/',
  };

  /// 이미지 경로를 검증하고 유효하지 않으면 기본값을 반환
  /// 
  /// [path] 검증할 이미지 경로
  /// [defaultPath] 유효하지 않을 때 사용할 기본 경로
  /// [logInvalid] 잘못된 경로를 로그로 출력할지 여부 (기본값: true)
  /// 
  /// Returns [String] 유효한 이미지 경로
  static String validate(String? path, String defaultPath, {bool logInvalid = true}) {
    if (path == null || path.isEmpty) {
      if (logInvalid) {
      }
      return defaultPath;
    }

    // 유효한 경로 패턴인지 검증
    for (String pattern in validPathPatterns) {
      if (path.startsWith(pattern)) {
        return path;
      }
    }

    // 유효하지 않은 경로
    if (logInvalid) {
    }
    return defaultPath;
  }

  /// 여러 이미지 경로를 한번에 검증
  /// 
  /// [paths] 검증할 경로들의 맵 (키: 필드명, 값: 경로)
  /// [defaultPaths] 각 필드별 기본 경로
  /// 
  /// Returns [Map<String, String>] 검증된 경로들의 맵
  static Map<String, String> validateMultiple(
    Map<String, String?> paths,
    Map<String, String> defaultPaths,
  ) {
    Map<String, String> validatedPaths = {};
    
    for (String key in paths.keys) {
      String? path = paths[key];
      String defaultPath = defaultPaths[key] ?? '';
      
      validatedPaths[key] = validate(path, defaultPath);
    }
    
    return validatedPaths;
  }

  /// JSON에서 이미지 경로들을 추출하여 검증
  /// 
  /// [json] JSON 데이터
  /// [imageFields] 이미지 경로가 포함된 필드명들
  /// [defaultPaths] 각 필드별 기본 경로
  /// 
  /// Returns [Map<String, String>] 검증된 이미지 경로들
  static Map<String, String> validateFromJson(
    Map<String, dynamic> json,
    List<String> imageFields,
    Map<String, String> defaultPaths,
  ) {
    Map<String, String?> paths = {};
    
    for (String field in imageFields) {
      paths[field] = json[field] as String?;
    }
    
    return validateMultiple(paths, defaultPaths);
  }

  /// 개발 모드에서만 이미지 경로 존재 여부를 검증
  /// 
  /// [path] 검증할 이미지 경로
  /// [context] 검증 컨텍스트 (디버깅용)
  static void validateImageExists(String path, String context) {
    if (kDebugMode) {
      // 실제 파일 존재 여부는 앱 빌드 시점에 확인됨
      // 여기서는 경로 패턴만 검증
      bool isValid = validPathPatterns.any((pattern) => path.startsWith(pattern));
      
      if (!isValid) {
      }
    }
  }

  /// 모든 유효한 이미지 경로 패턴을 반환
  static Set<String> getValidPathPatterns() => validPathPatterns;

  /// 특정 경로가 유효한 패턴인지 확인
  static bool isValidPath(String path) {
    return validPathPatterns.any((pattern) => path.startsWith(pattern));
  }
}
