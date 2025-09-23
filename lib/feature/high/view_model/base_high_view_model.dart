import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';


enum HighPane { problem, solution, custom }

class BaseHighViewModel extends ChangeNotifier {
  static const _limit = Duration(minutes: 90);
  final Stopwatch _think = Stopwatch();
  final Stopwatch _body = Stopwatch();
  Timer? _ticker;

  HighPane _pane = HighPane.problem;
  HighPane get pane => _pane;

  BaseHighViewModel() {
    _think.start();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void toProblem() { _pane = HighPane.problem; notifyListeners(); }
  void toSolution() { _pane = HighPane.solution; notifyListeners(); }
  void toCustom()  { _pane = HighPane.custom;  notifyListeners(); }

  void startThink() => _think.start();
  void pauseThink() => _think.stop();
  void resetThink() { _think.reset(); notifyListeners(); }

  void startBody() => _body.start();
  void pauseBody() => _body.stop();
  void resetBody() { _body.reset(); notifyListeners(); }

  Duration get thinkElapsed => _think.elapsed;
  Duration get bodyElapsed  => _body.elapsed;

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
  String get bodyText  => _fmt(bodyElapsed);
  bool get isTimeOver => thinkElapsed >= _limit;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}