import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';

/// 고등학교 미션 통합 ViewModel
class HighMissionViewModel extends ChangeNotifier {
  static const _limit = Duration(minutes: 90);
  final Stopwatch _think = Stopwatch();
  final Stopwatch _body = Stopwatch();
  Timer? _ticker;

  // 문제 데이터
  List<MissionQuestion> _questionList = [];
  List<MissionQuestion> get questionList => _questionList;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  MissionQuestion get currentQuestion => _questionList[_currentIndex];

  // 게임 상태
  DateTime? _gameStartTime;
  DateTime? get gameStartTime => _gameStartTime;

  // 타이머 상태
  Duration get thinkElapsed => _think.elapsed;
  Duration get bodyElapsed => _body.elapsed;

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

  /// 게임 시작
  void startGame(List<MissionQuestion> questions, {int initialIndex = 0}) {
    _questionList = questions;
    _currentIndex = initialIndex;
    _gameStartTime = DateTime.now();
    _think.start();
    _body.start();
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

  /// 타이머 시작
  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  /// 타이머 일시정지
  void pauseTimers() {
    _think.stop();
    _body.stop();
    _ticker?.cancel();
  }

  /// 타이머 재시작
  void resumeTimers() {
    _think.start();
    _body.start();
    _startTicker();
  }

  /// 타이머 리셋
  void resetTimers() {
    _think.reset();
    _body.reset();
    notifyListeners();
  }

  /// 게임 종료
  void endGame() {
    pauseTimers();
    _gameStartTime = null;
    _currentIndex = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
