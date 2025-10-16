import 'package:flutter/material.dart';
import '../view_model/middle_mission_view_model.dart';

abstract class Coordinator {
  Coordinator? parent;
  void start();
  bool handleBack(); // true면 back 처리 완료(시스템 pop 막기), false면 부모에 위임
  void dispose() {}
}

class MiddleMissionCoordinator extends ChangeNotifier implements Coordinator {
  @override
  Coordinator? parent;

  MiddleMissionViewModel? _viewModel;

  void setViewModel(MiddleMissionViewModel viewModel) {
    _viewModel = viewModel;
  }

  @override
  bool handleBack() {
    if (_viewModel == null) return false;
    
    final handled = _viewModel!.handleBack();
    if (handled) {
      notifyListeners();
    }
    
    return handled;
  }

  @override
  void start() {
    // 초기화 로직이 필요한 경우 여기에 구현
  }
}
