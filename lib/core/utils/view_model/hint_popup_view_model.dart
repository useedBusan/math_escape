import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../model/hint_model.dart';

class HintPopupViewModel extends ChangeNotifier {
  int _index = -1;
  List<HintEntry> _hints = const [];

  void setHints(List<HintEntry> hints) {
    _hints = hints;
    _index = -1;
    notifyListeners();
  }

  int get total => _hints.length;
  int get step  => (_index >= 0) ? (_index + 1) : 0;

  HintEntry? consumeNext() {
    if (_hints.isEmpty) return null;
    _index = (_index + 1) % _hints.length;
    return _hints[_index];
  }

  void reset({bool clearHints = false}) {
    _index = -1;
    if (clearHints) _hints = const [];
    notifyListeners();
  }

  ({String icon, Color color}) paletteOf(StudentGrade grade) {
    switch (grade) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return (icon: 'assets/images/hint_puri.png', color: CustomPink.s500);
      case StudentGrade.middle:
      case StudentGrade.high:
        return (icon: 'assets/images/bulb.png', color: CustomBlue.s500);
    }
  }

  HintModel buildModel({
    required StudentGrade grade,
    required HintEntry content,
    String? customUpText,
  }) {
    final p  = paletteOf(grade);
    final up = customUpText ?? (grade.isElementary ? '푸리 힌트 $step / $total' : '힌트 $step / $total');

    return HintModel(
      hintIcon: p.icon,
      upString: up,
      downString: content.text,
      hintImg: content.image,
      hintVideo: content.video,
      mainColor: p.color,
    );
  }
}

extension on StudentGrade {
  bool get isElementary =>
      this == StudentGrade.elementaryLow || this == StudentGrade.elementaryHigh;
}