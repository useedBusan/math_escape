import 'dart:convert';
import 'package:flutter/services.dart';
import '../../feature/high/model/high_qr_answer.dart';

class QRAnswerService {
  static final QRAnswerService _instance = QRAnswerService._internal();
  factory QRAnswerService() => _instance;
  QRAnswerService._internal();

  List<HighQRAnswer> _qrAnswers = [];
  
  // 각 학년별 QR 정답 데이터 (questionId -> correctAnswer)
  final Map<String, Map<int, String>> _qrAnswersByGrade = {
    'elementary_low': {},
    'elementary_high': {},
    'middle': {},
    'high': {}
  };

  Future<void> loadQrAnswers() async {
    try {
      // 기존 고등학교 QR 정답 로드 (하위 호환성)
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_qr_answers.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      _qrAnswers = jsonData.map((e) => HighQRAnswer.fromJson(e)).toList();
      print('고등학교 QR 정답 로드 완료: ${_qrAnswers.length}개');
      
      // 각 학년별 질문 데이터에서 QR 정보 추출
      await _loadElementaryLowQrAnswers();
      await _loadElementaryHighQrAnswers();
      await _loadMiddleQrAnswers();
      await _loadHighQrAnswers();
      
      print('모든 학년 QR 정답 로드 완료');
    } catch (e) {
      print('QR 정답 로드 오류: $e');
      _qrAnswers = [];
    }
  }

  String? getCorrectAnswer(int questionId) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.id == questionId);
      return answer.correctAnswer;
    } catch (e) {
      print('QR 정답 찾기 오류 (ID: $questionId): $e');
      return null;
    }
  }

  String? getCorrectAnswerByTitle(String title) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.title == title);
      return answer.correctAnswer;
    } catch (e) {
      print('QR 정답 찾기 오류 (Title: $title): $e');
      return null;
    }
  }

  String? getQRImagePathByTitle(String title) {
    try {
      final answer = _qrAnswers.firstWhere((answer) => answer.title == title);
      return answer.qrImagePath;
    } catch (e) {
      print('QR 이미지 경로 찾기 오류 (Title: $title): $e');
      return null;
    }
  }

  HighQRAnswer? getQRAnswerByTitle(String title) {
    try {
      return _qrAnswers.firstWhere((answer) => answer.title == title);
    } catch (e) {
      print('QR 답안 찾기 오류 (Title: $title): $e');
      return null;
    }
  }

  List<HighQRAnswer> get allQrAnswers => _qrAnswers;

  // ==================== 각 학년별 QR 정답 로드 ====================
  
  /// 초등학교 저학년 QR 정답 로드
  Future<void> _loadElementaryLowQrAnswers() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/elem_low/elem_low_question.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      
      for (var question in jsonData) {
        if (question['isqr'] == true) {
          final questionId = question['id'] as int;
          final correctAnswer = question['choices'][0] as String;
          _qrAnswersByGrade['elementary_low']![questionId] = correctAnswer;
          print('초등학교 저학년 QR 정답 로드: 문제 $questionId -> $correctAnswer');
        }
      }
    } catch (e) {
      print('초등학교 저학년 QR 정답 로드 오류: $e');
    }
  }

  /// 초등학교 고학년 QR 정답 로드
  Future<void> _loadElementaryHighQrAnswers() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/elem_high/elem_high_question.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      
      for (var question in jsonData) {
        if (question['isqr'] == true) {
          final questionId = question['id'] as int;
          final correctAnswer = question['answer'] as String;
          _qrAnswersByGrade['elementary_high']![questionId] = correctAnswer;
          print('초등학교 고학년 QR 정답 로드: 문제 $questionId -> $correctAnswer');
        }
      }
    } catch (e) {
      print('초등학교 고학년 QR 정답 로드 오류: $e');
    }
  }

  /// 중학교 QR 정답 로드
  Future<void> _loadMiddleQrAnswers() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/middle/middle_question.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      
      for (var question in jsonData) {
        if (question['isqr'] == true) {
          final questionId = question['id'] as int;
          final correctAnswer = question['answer'] as String;
          _qrAnswersByGrade['middle']![questionId] = correctAnswer;
          print('중학교 QR 정답 로드: 문제 $questionId -> $correctAnswer');
        }
      }
    } catch (e) {
      print('중학교 QR 정답 로드 오류: $e');
    }
  }

  /// 고등학교 QR 정답 로드 (기존 데이터와 연동)
  Future<void> _loadHighQrAnswers() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_level_question.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      
      for (var question in jsonData) {
        if (question['isqr'] == true) {
          final questionId = question['id'] as int;
          final correctAnswer = question['answer'][0] as String;
          _qrAnswersByGrade['high']![questionId] = correctAnswer;
          print('고등학교 QR 정답 로드: 문제 $questionId -> $correctAnswer');
        }
      }
    } catch (e) {
      print('고등학교 QR 정답 로드 오류: $e');
    }
  }

  // ==================== 통합 API ====================
  
  /// 학년과 문제 ID로 QR 정답 검색 (메인 API)
  String? getCorrectAnswerByGrade(String grade, int questionId) {
    try {
      final answer = _qrAnswersByGrade[grade]?[questionId];
      if (answer == null) {
        print('QR 정답 찾기 오류: 학년 "$grade", 문제 $questionId를 찾을 수 없음');
      }
      return answer;
    } catch (e) {
      print('QR 정답 찾기 오류 (Grade: $grade, ID: $questionId): $e');
      return null;
    }
  }

  /// 특정 학년의 모든 QR 답안 반환
  Map<int, String> getQrAnswersByGrade(String grade) {
    return _qrAnswersByGrade[grade] ?? {};
  }

  /// 특정 학년의 QR 문제 개수 반환
  int getQrProblemCount(String grade) {
    return _qrAnswersByGrade[grade]?.length ?? 0;
  }
}
