import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'high_timer_service.dart';


enum HighPane { problem, solution, custom }

class BaseHighViewModel extends ChangeNotifier {
  HighPane _pane = HighPane.problem;
  HighPane get pane => _pane;

  BaseHighViewModel() {
    // HighTimerService를 통해 타이머 상태 변경을 감지
    HighTimerService.instance.addListener(_onTimerUpdate);
  }

  void _onTimerUpdate() {
    notifyListeners();
  }

  void toProblem() { _pane = HighPane.problem; notifyListeners(); }
  void toSolution() { _pane = HighPane.solution; notifyListeners(); }
  void toCustom()  { _pane = HighPane.custom;  notifyListeners(); }

  void startThink() => HighTimerService.instance.resumeTimers();
  void pauseThink() => HighTimerService.instance.pauseTimers();
  void resetThink() => HighTimerService.instance.resetGame();

  void startBody() => HighTimerService.instance.resumeTimers();
  void pauseBody() => HighTimerService.instance.pauseTimers();
  void resetBody() => HighTimerService.instance.resetGame();

  // HighTimerService에서 타이머 데이터 가져오기
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

  @override
  void dispose() {
    HighTimerService.instance.removeListener(_onTimerUpdate);
    super.dispose();
  }
}