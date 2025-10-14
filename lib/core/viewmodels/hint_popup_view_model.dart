import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../app/theme/app_colors.dart';
import '../models/hint_model.dart';


class HintPopupViewModel extends ChangeNotifier {
  int _index = -1;
  List<HintEntry> _hints = const [];
  int? _currentMissionId; // 현재 미션 ID 추적

  void setHints(List<HintEntry> hints, {int? missionId}) {
    // 다른 미션의 힌트인 경우에만 새로 설정
    if (_currentMissionId != missionId) {
      _hints = hints;
      _index = -1;
      _currentMissionId = missionId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (hasListeners) notifyListeners();
      });
    }
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
    if (clearHints) {
      _hints = const [];
      _currentMissionId = null;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) notifyListeners();
    });
  }

  ({String icon, Color color}) paletteOf(StudentGrade grade) {
    switch (grade) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return (icon: 'assets/images/common/hintFuri.png', color: CustomPink.s500);
      case StudentGrade.middle:
      case StudentGrade.high:
        return (icon: 'assets/images/middle/middleHint.png', color: CustomBlue.s500);
    }
  }

  HintModel buildModel({
    required StudentGrade grade,
    required HintEntry content,
    String? customUpText,
  }) {
    final p  = paletteOf(grade);
    String up;
    if (customUpText != null) {
      up = customUpText;
    } else if (grade.isElementary) {
      if (total <= 1) {
        up = '푸리 힌트';
      } else {
        up = '푸리 힌트 $step / $total';
      }
    } else {
      if (total <= 1) {
        up = '힌트';
      } else {
        up = '힌트 $step / $total';
      }
    }

    return HintModel(
      hintIcon: p.icon,
      upString: up,
      downString: content.text,
      hintImg: content.images,
      hintVideo: content.videos,
      mainColor: p.color,
    );
  }
}

extension on StudentGrade {
  bool get isElementary =>
      this == StudentGrade.elementaryLow || this == StudentGrade.elementaryHigh;
}