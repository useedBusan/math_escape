import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import 'high_timer_service.dart';

/// 고등학교 미션 통합 view_model
class HighMissionViewModel extends ChangeNotifier {

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

  MissionQuestion? get currentQuestion => 
      _questionList.isNotEmpty ? _questionList[_currentIndex] : null;

  // 게임 완료 상태
  bool get isGameCompleted => _gameCompleted;
  bool _gameCompleted = false;

  // 게임 상태
  DateTime? _gameStartTime;
  DateTime? get gameStartTime => _gameStartTime;

  // 답변 입력 컨트롤러
  final TextEditingController answerController = TextEditingController();
  bool _isAnswerControllerDisposed = false;

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

  /// 게임 시작, timer 초기화 로직
  void startGame(List<MissionQuestion> questions, {int initialIndex = 0}) {
    _questionList = questions;
    _currentIndex = initialIndex;

    // 게임이 이미 시작되지 않은 경우에만 시작 시간 설정
    if (_gameStartTime == null) {
      _gameStartTime = DateTime.now();
      HighTimerService.instance.startGame(_gameStartTime!);
    } else {
      // 이미 게임이 시작된 경우, 타이머 서비스의 시작 시간을 유지
      // HighTimerService는 싱글톤이므로 이미 시작된 타이머를 유지
    }

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
  bool isLastQuestion(int stage) {
    // 문제 리스트에서 가장 높은 stage를 찾아서 마지막 문제인지 확인
    final maxStage = _questionList
        .map((q) => q.stage)
        .reduce((a, b) => a > b ? a : b);
    return stage == maxStage;
  }

  /// 게임 완료 처리
  void completeGame() {
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

  /// 게임 종료
  void endGame() {
    HighTimerService.instance.endGame();
    _gameStartTime = null;
    _safeDisposeAnswerController();
    _currentIndex = 0;
    _gameCompleted = false;
    notifyListeners();
  }

  /// 게임 완전 리셋 (새 게임 시작 시 사용)
  void resetGame() {
    HighTimerService.instance.resetGame();
    _gameStartTime = null;
    _currentIndex = 0;
    _gameCompleted = false;
    _questionList.clear();
    notifyListeners();
  }

  /// 안전한 answerController dispose
  void _safeDisposeAnswerController() {
    if (!_isAnswerControllerDisposed) {
      answerController.dispose();
      _isAnswerControllerDisposed = true;
    }
  }

  /// 모든 상태 완전 해제 (홈으로 돌아갈 때 사용)
  void disposeAll() {
    HighTimerService.instance.endGame();
    _gameStartTime = null;
    _currentIndex = 0;
    _gameCompleted = false;
    _questionList.clear();
    _safeDisposeAnswerController();
    notifyListeners();
  }

}
