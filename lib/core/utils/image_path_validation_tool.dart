import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'image_path_validator.dart';

/// 개발 중 이미지 경로 유효성을 검증하는 도구
class ImagePathValidationTool {
  /// 모든 JSON 파일에서 이미지 경로를 검증
  static Future<void> validateAllJsonFiles() async {
    if (!kDebugMode) return;


    final List<String> jsonFiles = [
      'assets/data/elem_low/elem_low_conversation.json',
      'assets/data/elem_low/elem_low_intro.json',
      'assets/data/elem_low/elem_low_question.json',
      'assets/data/elem_high/elem_high_conversation.json',
      'assets/data/elem_high/elem_high_intro.json',
      'assets/data/elem_high/elem_high_question.json',
      'assets/data/middle/middle_conversation.json',
      'assets/data/middle/middle_intro.json',
      'assets/data/middle/middle_question.json',
      'assets/data/high/high_level_answer.json',
      'assets/data/high/high_level_question.json',
    ];

    int totalIssues = 0;

    for (String filePath in jsonFiles) {
      try {
        final issues = await _validateJsonFile(filePath);
        totalIssues += issues;
      } catch (e) {
        totalIssues++;
      }
    }

  }

  /// 특정 JSON 파일의 이미지 경로를 검증
  static Future<int> _validateJsonFile(String filePath) async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      final dynamic jsonData = json.decode(jsonString);
      
      int issues = 0;
      
      if (jsonData is List) {
        for (int i = 0; i < jsonData.length; i++) {
          final item = jsonData[i] as Map<String, dynamic>;
          issues += _validateJsonItem(item, filePath, i);
        }
      } else if (jsonData is Map<String, dynamic>) {
        issues += _validateJsonItem(jsonData, filePath, 0);
      }

      if (issues == 0) {
      } else {
      }

      return issues;
    } catch (e) {
      return 1;
    }
  }

  /// JSON 아이템의 이미지 경로를 검증
  static int _validateJsonItem(Map<String, dynamic> item, String filePath, int index) {
    int issues = 0;
    
    // 이미지 경로 필드들
    final List<String> imageFields = [
      'speakerImg', 'backImg', 'puri_image', 'back_image', 
      'questionImage', 'hintImage', 'bannerImg'
    ];

    for (String field in imageFields) {
      final String? path = item[field] as String?;
      
      if (path != null && path.isNotEmpty) {
        if (!ImagePathValidator.isValidPath(path)) {
          issues++;
        } else {
          // 유효한 경로인 경우에도 개발 모드에서 추가 검증
          ImagePathValidator.validateImageExists(path, '$filePath[$index].$field');
        }
      }
    }

    // 중첩된 구조 검증 (middle_conversation.json의 talks 배열 등)
    if (item.containsKey('talks') && item['talks'] is List) {
      final List<dynamic> talks = item['talks'] as List<dynamic>;
      for (int i = 0; i < talks.length; i++) {
        final talk = talks[i] as Map<String, dynamic>;
        issues += _validateJsonItem(talk, '$filePath[$index].talks[$i]', i);
      }
    }

    return issues;
  }

  /// 특정 이미지 파일이 실제로 존재하는지 확인
  static Future<bool> imageFileExists(String imagePath) async {
    try {
      // Flutter에서는 rootBundle을 사용하여 에셋 존재 여부 확인
      await rootBundle.loadString(imagePath);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 모든 이미지 경로의 실제 파일 존재 여부를 검증
  static Future<void> validateImageFileExistence() async {
    if (!kDebugMode) return;


    final Set<String> allImagePaths = await _extractAllImagePaths();
    int missingFiles = 0;

    for (String path in allImagePaths) {
      final exists = await imageFileExists(path);
      if (!exists) {
        missingFiles++;
      }
    }

  }

  /// 모든 JSON 파일에서 이미지 경로를 추출
  static Future<Set<String>> _extractAllImagePaths() async {
    final Set<String> imagePaths = <String>{};
    
    final List<String> jsonFiles = [
      'assets/data/elem_low/elem_low_conversation.json',
      'assets/data/elem_low/elem_low_intro.json',
      'assets/data/elem_low/elem_low_question.json',
      'assets/data/elem_high/elem_high_conversation.json',
      'assets/data/elem_high/elem_high_intro.json',
      'assets/data/elem_high/elem_high_question.json',
      'assets/data/middle/middle_conversation.json',
      'assets/data/middle/middle_intro.json',
      'assets/data/middle/middle_question.json',
      'assets/data/high/high_level_answer.json',
      'assets/data/high/high_level_question.json',
    ];

    for (String filePath in jsonFiles) {
      try {
        final String jsonString = await rootBundle.loadString(filePath);
        final dynamic jsonData = json.decode(jsonString);
        
        _extractPathsFromData(jsonData, imagePaths);
      } catch (e) {
      }
    }

    return imagePaths;
  }

  /// JSON 데이터에서 이미지 경로를 재귀적으로 추출
  static void _extractPathsFromData(dynamic data, Set<String> imagePaths) {
    if (data is Map<String, dynamic>) {
      for (String key in data.keys) {
        final value = data[key];
        
        if (key.contains('image') || key.contains('Image') || key.contains('img') || key.contains('Img')) {
          if (value is String && value.startsWith('assets/images/')) {
            imagePaths.add(value);
          }
        }
        
        if (value is Map || value is List) {
          _extractPathsFromData(value, imagePaths);
        }
      }
    } else if (data is List) {
      for (dynamic item in data) {
        _extractPathsFromData(item, imagePaths);
      }
    }
  }

  /// 개발 모드에서 앱 시작 시 자동 검증 실행
  static void runValidationOnStartup() {
    if (kDebugMode) {
      // 앱 시작 후 잠시 대기 후 검증 실행
      Future.delayed(const Duration(seconds: 2), () {
        validateAllJsonFiles();
      });
    }
  }
}
