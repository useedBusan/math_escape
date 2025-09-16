import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../model/hint_model.dart';

/// 힌트 2단계(1/2) 순환과 grade→색/이미지 매핑만 담당하는 가벼운 VM
class HintPopupViewModel extends ChangeNotifier {
  int _stepIdx = 0;

  int consumeNextStep() {
    _stepIdx = (_stepIdx % 2) + 1;
    return _stepIdx;
  }

  void reset() {
    _stepIdx = 0;
    notifyListeners();
  }

  /// grade 별 이미지/색 매핑
  ({String img, Color color}) paletteOf(StudentGrade grade) {
    switch (grade) {
      case StudentGrade.elementaryLow:
      case StudentGrade.elementaryHigh:
        return (img: 'assets/images/hint_puri.png', color: CustomPink.s500);
      case StudentGrade.middle:
      case StudentGrade.high:
        return (img: 'assets/images/bulb.png', color: CustomBlue.s500);
    }
  }

  /// 힌트 모델 조립 (힌트 텍스트만 넘겨주면 됨)
  HintModel buildModel({
    required StudentGrade grade,
    required int step,
    required String hintText,
    String? customUpText,
  }) {
    final p = paletteOf(grade);
    final up = customUpText ?? (grade.isElementary ? '푸리 힌트 $step / 2' : '힌트 $step / 2');
    return HintModel(
      img: p.img,
      upString: up,
      downString: hintText,
      mainColor: p.color,
    );
  }
}

// 간단 헬퍼: 초등 여부
extension on StudentGrade {
  bool get isElementary =>
      this == StudentGrade.elementaryLow || this == StudentGrade.elementaryHigh;
}