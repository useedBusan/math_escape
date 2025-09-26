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

  // 답변 입력 컨트롤러
  final TextEditingController answerController = TextEditingController();

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

  // UI에서 사용하는 getter들
  String get thinkingTime => thinkText;
  String get bodyTime => bodyTimeText;
  double get progress => thinkProgress;

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
      notifyListeners();
    });
  }

  /// 타이머 일시정지
  void pauseTimers() {
    _ticker?.cancel();
  }

  /// 타이머 재시작
  void resumeTimers() {
    _startTicker();
  }

  /// 게임 종료
  void endGame() {
    pauseTimers();
    _gameStartTime = null;
    answerController.dispose();
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

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
