import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import 'high_mission_view_model.dart';


enum HighPane { problem, solution, custom }

class BaseHighViewModel extends ChangeNotifier {
  HighPane _pane = HighPane.problem;
  HighPane get pane => _pane;

  // HighMissionViewModel 인스턴스 사용
  HighMissionViewModel get _timer => HighMissionViewModel.instance;

  BaseHighViewModel() {
    // HighMissionViewModel의 타이머를 구독
    _timer.addListener(() {
      notifyListeners();
    });
  }

  void toProblem() { _pane = HighPane.problem; notifyListeners(); }
  void toSolution() { _pane = HighPane.solution; notifyListeners(); }
  void toCustom()  { _pane = HighPane.custom;  notifyListeners(); }

  // HighMissionViewModel로 위임
  void startThink() => _timer.resumeTimers();
  void pauseThink() => _timer.pauseTimers();
  void resetThink() => _timer.resetGame();

  void startBody() => _timer.resumeTimers();
  void pauseBody() => _timer.pauseTimers();
  void resetBody() => _timer.resetGame();

  Duration get thinkElapsed => _timer.thinkElapsed;
  Duration get bodyElapsed => _timer.bodyElapsed;

  double get thinkProgress => _timer.thinkProgress;
  Color get progressColor => _timer.progressColor;

  String get thinkText => _timer.thinkText;
  String get bodyText => _timer.bodyTimeText;
  bool get isTimeOver => _timer.isTimeOver;

  @override
  void dispose() {
    _timer.removeListener(() {
      notifyListeners();
    });
    super.dispose();
  }
}