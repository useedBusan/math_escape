import 'dart:convert';
import 'package:flutter/services.dart';

/// 데이터 로딩을 담당하는 서비스
class DataService {
  /// JSON 파일에서 데이터를 로드
  /// [filePath] assets 폴더 내 JSON 파일 경로
  /// Returns [Map<String, dynamic>] 파싱된 JSON 데이터
  Future<Map<String, dynamic>> loadJsonData(String filePath) async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      return json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load JSON data from $filePath: $e');
    }
  }

  /// JSON 파일에서 리스트 데이터를 로드
  /// [filePath] assets 폴더 내 JSON 파일 경로
  /// Returns [List<dynamic>] 파싱된 JSON 리스트 데이터
  Future<List<dynamic>> loadJsonList(String filePath) async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList;
    } catch (e) {
      throw Exception('Failed to load JSON list from $filePath: $e');
    }
  }

  /// 미션 데이터를 로드
  /// [grade] 학년 ('elementary_low', 'elementary_high', 'middle', 'high')
  /// Returns [Map<String, dynamic>] 미션 데이터와 대화 데이터
  Future<Map<String, dynamic>> loadMissionData(String grade) async {
    try {
      // 학년별 데이터 파일 경로 설정
      String missionFilePath;
      String talkFilePath;

      switch (grade) {
        case 'elementary_low':
          missionFilePath = 'assets/data/elem_low/elem_low_question.json';
          talkFilePath = 'assets/data/elem_low/elem_low_conversation.json';
          break;
        case 'elementary_high':
          missionFilePath = 'assets/data/elem_high/elem_high_question.json';
          talkFilePath = 'assets/data/elem_high/elem_high_conversation.json';
          break;
        case 'middle':
          missionFilePath = 'assets/data/middle/middle_question.json';
          talkFilePath = 'assets/data/middle/middle_conversation.json';
          break;
        case 'high':
          missionFilePath = 'assets/data/high/high_question.json';
          talkFilePath = 'assets/data/high/high_conversation.json';
          break;
        default:
          throw Exception('Unknown grade: $grade');
      }

      // 미션 데이터와 대화 데이터를 병렬로 로드
      final results = await Future.wait([
        loadJsonList(missionFilePath),
        loadJsonList(talkFilePath),
      ]);

      return {
        'missions': results[0],
        'talks': results[1],
      };
    } catch (e) {
      throw Exception('Failed to load mission data for $grade: $e');
    }
  }
}
