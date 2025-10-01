import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_colors.dart';
import 'package:math_escape/feature/high/model/high_mission_answer.dart';
import 'high_timer_service.dart';

/// 고등학교 답변 화면 ViewModel
class HighAnswerViewModel extends ChangeNotifier {

  // 싱글톤 인스턴스
  static final HighAnswerViewModel _instance = HighAnswerViewModel._internal();
  static HighAnswerViewModel get instance => _instance;

  HighAnswerViewModel._internal();

  // 답변 데이터
  MissionAnswer? _currentAnswer;
  MissionAnswer? get currentAnswer => _currentAnswer;

  // 게임 상태
  DateTime? _gameStartTime;
  DateTime? get gameStartTime => _gameStartTime;

  // 힌트에서 온 답변인지 여부
  bool _isFromHint = false;
  bool get isFromHint => _isFromHint;

  // 타이머 서비스 위임
  Duration get thinkElapsed => HighTimerService.instance.thinkElapsed;
  Duration get bodyElapsed => HighTimerService.instance.bodyElapsed;
  double get thinkProgress => HighTimerService.instance.thinkProgress;
  Color get progressColor {
    if (thinkProgress >= 0.75) {
      return CustomPink.s500;
    }
    return CustomBlue.s500;
  }
  String get thinkText => HighTimerService.instance.thinkText;
  String get bodyText => HighTimerService.instance.bodyText;
  bool get isTimeOver => HighTimerService.instance.isTimeOver;
  String get thinkingTime => HighTimerService.instance.thinkingTime;
  String get bodyTime => HighTimerService.instance.bodyTime;
  double get progress => HighTimerService.instance.progress;
  String get bodyTimeText => HighTimerService.instance.bodyTimeText;

  /// 일반 답변 데이터 로드 (high_level_answer.json)
  Future<MissionAnswer> loadAnswerById(int id) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_level_answer.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      final answer = jsonData
          .map((e) => MissionAnswer.fromJson(e))
          .firstWhere((a) => a.id == id);
      
      _currentAnswer = answer;
      _isFromHint = false;
      notifyListeners();
      return answer;
    } catch (e) {
      rethrow;
    }
  }

  /// 힌트 답변 데이터 로드 (high_hint_answer.json)
  Future<MissionAnswer> loadHintAnswerById(int id) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_hint_answer.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);
      final answer = jsonData
          .map((e) => MissionAnswer.fromJson(e))
          .firstWhere((a) => a.id == id);
      
      _currentAnswer = answer;
      _isFromHint = true;
      notifyListeners();
      return answer;
    } catch (e) {
      rethrow;
    }
  }

  /// 답변 화면 초기화
  void initializeAnswer({
    required MissionAnswer answer,
    required DateTime gameStartTime,
    required bool isFromHint,
  }) {
    _currentAnswer = answer;
    _gameStartTime = gameStartTime;
    _isFromHint = isFromHint;
    
    notifyListeners();
  }

  /// 다음 버튼 처리 로직
  void handleNextButton({
    required int currentIndex,
    required int questionListLength,
    required VoidCallback onNavigateToNext,
    required VoidCallback onNavigateBack,
    required VoidCallback onComplete,
  }) {
    if (_isFromHint) {
      // 힌트에서 온 경우: HighAnswer pop → HighMission으로 돌아가기
      onNavigateBack();
    } else {
      // 일반적인 경우: HighAnswer pop → HighMissionView에서 다음 문제
      if (currentIndex + 1 < questionListLength) {
        onNavigateToNext();
      } else {
        onComplete();
      }
    }
  }

  /// 타이머 일시정지
  void pauseTimers() {
    HighTimerService.instance.pauseTimers();
  }

  /// 타이머 재시작
  void resumeTimers() {
    HighTimerService.instance.resumeTimers();
  }

  /// 답변 화면 종료
  void endAnswer() {
    HighTimerService.instance.endGame();
    _currentAnswer = null;
    _gameStartTime = null;
    _isFromHint = false;
    notifyListeners();
  }

  /// 답변 화면 완전 리셋
  void resetAnswer() {
    HighTimerService.instance.resetGame();
    _currentAnswer = null;
    _gameStartTime = null;
    _isFromHint = false;
    notifyListeners();
  }

  /// 모든 상태 완전 해제 (홈으로 돌아갈 때 사용)
  void disposeAll() {
    HighTimerService.instance.endGame();
    _currentAnswer = null;
    _gameStartTime = null;
    _isFromHint = false;
    notifyListeners();
  }

}
