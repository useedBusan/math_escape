import 'dart:async';
import 'package:flutter/material.dart';

/// 고등학교 미션 전용 타이머 서비스 (싱글톤)
class HighTimerService extends ChangeNotifier {
  static const _limit = Duration(minutes: 90);
  Timer? _ticker;

  // 싱글톤 인스턴스
  static final HighTimerService _instance = HighTimerService._internal();
  static HighTimerService get instance => _instance;

  HighTimerService._internal();

  // 게임 시작 시간
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

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get thinkText => _fmt(thinkElapsed);
  String get bodyText => bodyTimeText;
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
    return '$years년 $months개월';
  }

  /// 게임 시작 (한 번만 호출)
  void startGame(DateTime startTime) {
    if (_gameStartTime == null) {
      _gameStartTime = startTime;
      _startTicker();
      notifyListeners();
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
    notifyListeners();
  }

  /// 게임 완전 리셋
  void resetGame() {
    pauseTimers();
    _gameStartTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
