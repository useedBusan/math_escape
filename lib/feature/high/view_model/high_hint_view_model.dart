import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_colors.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'high_timer_service.dart';

/// 고등학교 힌트 미션 ViewModel
class HighHintViewModel extends ChangeNotifier {

  // 싱글톤 인스턴스
  static final HighHintViewModel _instance = HighHintViewModel._internal();
  static HighHintViewModel get instance => _instance;

  HighHintViewModel._internal();

  // 힌트 문제 데이터
  List<MissionQuestion> _hintQuestionList = [];
  List<MissionQuestion> get hintQuestionList => _hintQuestionList;

  int _currentHintIndex = 0;
  int get currentHintIndex => _currentHintIndex;

  MissionQuestion? get currentHintQuestion {
    if (_hintQuestionList.isEmpty) return null;
    print('DEBUG: currentHintQuestion getter - _currentHintIndex: $_currentHintIndex, list length: ${_hintQuestionList.length}');
    if (_currentHintIndex >= 0 && _currentHintIndex < _hintQuestionList.length) {
      final question = _hintQuestionList[_currentHintIndex];
      print('DEBUG: currentHintQuestion getter - returning: id: ${question.id}, stage: ${question.stage}, title: ${question.title}');
      return question;
    }
    return null;
  }

  // 게임 완료 상태
  bool get isGameCompleted => _gameCompleted;
  bool _gameCompleted = false;

  // 게임 상태
  DateTime? _gameStartTime;
  DateTime? get gameStartTime => _gameStartTime;

  // 답변 입력 컨트롤러
  final TextEditingController answerController = TextEditingController();

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

  /// 힌트 문제 데이터 로드
  Future<void> loadHintQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/high/high_hint_hint.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      _hintQuestionList = jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      // 힌트 문제 로드 실패
    }
  }

  /// 힌트 게임 시작
  void startHintGame({int initialIndex = 0}) {
    print('DEBUG: startHintGame called with initialIndex: $initialIndex, current _currentHintIndex: $_currentHintIndex');
    // startHintGame에서 _currentHintIndex를 덮어쓰지 않도록 수정
    // _currentHintIndex = initialIndex;
    
    // 게임이 이미 시작되지 않은 경우에만 시작 시간 설정
    if (_gameStartTime == null) {
      _gameStartTime = DateTime.now();
      HighTimerService.instance.startGame(_gameStartTime!);
    }

    notifyListeners();
  }

  /// 특정 stage의 힌트 문제로 이동
  void goToHintByStage(int stage) {
    print('DEBUG: goToHintByStage called with stage: $stage');
    print('DEBUG: _hintQuestionList length: ${_hintQuestionList.length}');
    for (int i = 0; i < _hintQuestionList.length; i++) {
      print('DEBUG: hint[$i] - id: ${_hintQuestionList[i].id}, stage: ${_hintQuestionList[i].stage}, title: ${_hintQuestionList[i].title}');
    }
    
    final index = _hintQuestionList.indexWhere((q) => q.stage == stage);
    print('DEBUG: found index: $index');
    
    if (index != -1) {
      _currentHintIndex = index;
      print('DEBUG: set _currentHintIndex to: $index');
      notifyListeners();
    } else {
      // 해당 stage가 없으면 첫 번째 힌트로 이동
      _currentHintIndex = 0;
      print('DEBUG: stage not found, set _currentHintIndex to: 0');
      notifyListeners();
    }
  }

  /// 다음 힌트 문제로 이동
  void nextHintQuestion() {
    if (_currentHintIndex + 1 < _hintQuestionList.length) {
      _currentHintIndex++;
      notifyListeners();
    }
  }

  /// 특정 힌트 문제로 이동
  void goToHintQuestion(int index) {
    if (index >= 0 && index < _hintQuestionList.length) {
      _currentHintIndex = index;
      notifyListeners();
    }
  }

  /// 힌트 문제 ID로 이동
  void goToHintQuestionById(int id) {
    final index = _hintQuestionList.indexWhere((q) => q.id == id);
    if (index != -1) {
      goToHintQuestion(index);
    }
  }

  /// 마지막 힌트 문제인지 확인
  bool isLastHintQuestion(int stage) {
    if (_hintQuestionList.isEmpty) return false;
    final maxStage = _hintQuestionList
        .map((q) => q.stage)
        .reduce((a, b) => a > b ? a : b);
    return stage == maxStage;
  }

  /// 힌트 게임 완료 처리
  void completeHintGame() {
    _gameCompleted = true;
    HighTimerService.instance.pauseTimers();
    notifyListeners();
  }

  /// 타이머 일시정지
  void pauseTimers() {
    HighTimerService.instance.pauseTimers();
  }

  /// 타이머 재시작
  void resumeTimers() {
    HighTimerService.instance.resumeTimers();
  }

  /// 힌트 게임 종료
  void endHintGame() {
    HighTimerService.instance.endGame();
    _gameStartTime = null;
    answerController.dispose();
    _currentHintIndex = 0;
    _gameCompleted = false;
    notifyListeners();
  }

  /// 힌트 게임 완전 리셋
  void resetHintGame() {
    HighTimerService.instance.resetGame();
    _gameStartTime = null;
    _currentHintIndex = 0;
    _gameCompleted = false;
    _hintQuestionList.clear();
    notifyListeners();
  }

}
