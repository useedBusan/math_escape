import 'package:flutter/material.dart';
import 'flow_step.dart';
import '../view_model/elementary_low_mission_view_model.dart';

abstract class Coordinator {
  Coordinator? parent;
  void start();
  bool handleBack(); // true면 back 처리 완료(시스템 pop 막기), false면 부모에 위임
  void dispose() {}
}

class ElementaryLowMissionCoordinator extends ChangeNotifier implements Coordinator {
  @override
  Coordinator? parent;

  final List<FlowStep> _history = [FlowStep(FlowStepType.conversation, 1)];
  
  FlowStep get current => _history.last;
  List<FlowStep> get history => List.unmodifiable(_history);
  
  bool get isInIntro => current.type == FlowStepType.intro;
  bool get isInConversation => current.type == FlowStepType.conversation;
  bool get isInQuestion => current.type == FlowStepType.question;
  
  // VM 참조 - currentIndex의 단일 소스
  ElementaryLowMissionViewModel? _viewModel;
  
  void setViewModel(ElementaryLowMissionViewModel viewModel) {
    _viewModel = viewModel;
  }
  
  // VM의 currentIndex를 단일 소스로 사용
  int get currentQuestionIndex => _viewModel?.currentIndex ?? 0;
  
  // VM 참조를 위한 콜백
  Function(int)? _onQuestionIndexChanged;
  
  void setQuestionIndexCallback(Function(int) callback) {
    _onQuestionIndexChanged = callback;
  }
  
  void toIntro() {
    _history.add(FlowStep(FlowStepType.intro, 1));
    notifyListeners();
  }

  void toConversation(int stage) {
    _history.add(FlowStep(FlowStepType.conversation, stage));
    notifyListeners();
  }

  void toQuestion(int stage) {
    _history.add(FlowStep(FlowStepType.question, stage));
    
    // elemLow 플로우: conversation(1) → question(1) → conversation(2) → question(2)
    // question(1) = index 0, question(2) = index 1, question(3) = index 2
    final questionIndex = stage - 1; // stage는 1-based, index는 0-based
    _viewModel?.setCurrentIndexByCoordinator(questionIndex);
    
    notifyListeners();
  }

  bool popStepInternal() {
    if (_history.length <= 1) {
      return true; // 더 이상 이전 없음 → Route pop 허용
    }
    final removed = _history.removeLast();
    
    // question 단계로 돌아갈 때 VM의 currentIndex 직접 설정
    if (removed.type == FlowStepType.question) {
      // 현재 남은 히스토리에서 마지막 question step 찾기
      int lastQuestionStage = 1; // 기본값
      for (int i = _history.length - 1; i >= 0; i--) {
        if (_history[i].type == FlowStepType.question) {
          lastQuestionStage = _history[i].stage;
          break;
        }
      }
      final questionIndex = lastQuestionStage - 1; // stage는 1-based, index는 0-based
      _viewModel?.setCurrentIndexByCoordinator(questionIndex);
    }
    
    notifyListeners();
    return false; // Route pop 하지 않음
  }

  @override
  bool handleBack() {
    return !popStepInternal(); // 처리했으면 true 리턴
  }

  @override
  void start() {
    // 초기화 로직이 필요한 경우 여기에 구현
  }

}
