import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';

/// 고등학교 미션 통합 ViewModel
class HighMissionViewModel extends ChangeNotifier {
  static const _limit = Duration(minutes: 90);
  Timer? _ticker;

  // 싱글톤 인스턴스
  static final HighMissionViewModel _instance =
      HighMissionViewModel._internal();
  static HighMissionViewModel get instance => _instance;

  HighMissionViewModel._internal();

  // 문제 데이터
  List<MissionQuestion> _questionList = [];
  List<MissionQuestion> get questionList => _questionList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  MissionQuestion get currentQuestion => _questionList[_currentIndex];

  // 게임 완료 상태
  bool get isGameCompleted => _gameCompleted;
  bool _gameCompleted = false;

  // 게임 상태
  DateTime? _gameStartTime;
  DateTime? get gameStartTime => _gameStartTime;

  // 타이머 상태
  Duration get thinkElapsed {
    if (_gameStartTime == null) return Duration.zero;
    return DateTime.now().difference(_gameStartTime!);
  }

  Duration get bodyElapsed => thinkElapsed;

  double get thinkProgress {
    final ratio = thinkElapsed.inSeconds / _limit.inSeconds;
    return ratio.clamp(0.0, 1.0);
  }

  Color get progressColor {
    if (thinkProgress >= 0.75) {
      return CustomPink.s500;
    }
    return CustomBlue.s500;
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get thinkText => _fmt(thinkElapsed);
  String get bodyText => _fmt(bodyElapsed);
  bool get isTimeOver => thinkElapsed >= _limit;

  // 몸의 시간 계산 (1분 = 1년, 5초 = 1개월)
  String get bodyTimeText {
    final totalSeconds = thinkElapsed.inSeconds;
    final years = totalSeconds ~/ 60;
    final months = (totalSeconds % 60) ~/ 5;
    return '$years년, $months개월';
  }

  /// 게임 시작, timer 초기화 로직
  void startGame(List<MissionQuestion> questions, {int initialIndex = 0}) {
    _questionList = questions;
    _currentIndex = initialIndex;

    // 게임이 이미 시작되지 않은 경우에만 시작 시간 설정
    if (_gameStartTime == null) {
      _gameStartTime = DateTime.now();
    }

    _startTicker();
    notifyListeners();
  }

  /// 다음 문제로 이동
  void nextQuestion() {
    if (_currentIndex + 1 < _questionList.length) {
      _currentIndex++;
      notifyListeners();
    }
  }

  /// 특정 문제로 이동
  void goToQuestion(int index) {
    if (index >= 0 && index < _questionList.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// 문제 ID로 이동
  void goToQuestionById(int id) {
    final index = _questionList.indexWhere((q) => q.id == id);
    if (index != -1) {
      goToQuestion(index);
    }
  }

  /// 마지막 문제인지 확인
  bool isLastQuestion(int questionId) {
    // 문제 리스트에서 가장 높은 ID를 찾아서 마지막 문제인지 확인
    final maxId = _questionList
        .map((q) => q.id)
        .reduce((a, b) => a > b ? a : b);
    return questionId == maxId;
  }

  /// 게임 완료 처리
  void completeGame() {
    _gameCompleted = true;
    pauseTimers();
    notifyListeners();
  }

  /// 타이머 시작
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_gameCompleted && _gameStartTime != null) {
        notifyListeners();
      }
    });
  }

  /// 타이머 일시정지
  void pauseTimers() {
    _ticker?.cancel();
    _ticker = null;
  }

  /// 타이머 재시작
  void resumeTimers() {
    if (_gameStartTime != null && !_gameCompleted) {
      _startTicker();
    }
  }

  /// 게임 종료
  void endGame() {
    pauseTimers();
    _gameStartTime = null;
    _currentIndex = 0;
    _gameCompleted = false;
    notifyListeners();
  }

  /// 게임 완전 리셋 (새 게임 시작 시 사용)
  void resetGame() {
    pauseTimers();
    _gameStartTime = null;
    _currentIndex = 0;
    _gameCompleted = false;
    _questionList.clear();
    notifyListeners();
  }

  /// 특정 문제로 안전하게 이동 (메모리 누수 방지)
  void safeGoToQuestionById(int id) {
    // 현재 타이머 일시정지
    pauseTimers();

    final index = _questionList.indexWhere((q) => q.id == id);
    if (index != -1) {
      _currentIndex = index;
      notifyListeners();

      // 타이머 재시작
      resumeTimers();
    }
  }

  /// 힌트 처리 - 타입에 따라 다른 동작 수행
  void handleHint() {
    final question = currentQuestion;

    // hintType이 없으면 기본 팝업 동작 (기존 호환성 유지)
    if (question.hintType == null) {
      // 기존 로직 유지
      if (question.title == '역설, 혹은 모호함_1') {
        goToQuestionById(2);
      }
      // 다른 문제들은 팝업 표시 (외부에서 처리)
      return;
    }

    // 새로운 힌트 시스템
    switch (question.hintType) {
      case 'problem':
        if (question.hintTargetId != null) {
          goToQuestionById(question.hintTargetId!);
        }
        break;
      case 'popup':
        // 팝업 표시 (외부에서 처리)
        break;
      default:
        // 기본 동작
        break;
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
