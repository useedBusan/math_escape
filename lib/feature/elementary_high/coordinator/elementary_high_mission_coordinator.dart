import 'package:flutter/material.dart';
import 'flow_step.dart';

abstract class Coordinator {
  Coordinator? parent;
  void start();
  bool handleBack(); // true면 back 처리 완료(시스템 pop 막기), false면 부모에 위임
  void dispose() {}
}

class ElementaryHighMissionCoordinator extends ChangeNotifier implements Coordinator {
  @override
  Coordinator? parent;

  final List<FlowStep> _history = [FlowStep(FlowStepType.question, 1)];
  
  FlowStep get current => _history.last;
  List<FlowStep> get history => List.unmodifiable(_history);
  
  bool get isInIntro => current.type == FlowStepType.intro;
  bool get isInConversation => current.type == FlowStepType.conversation;
  bool get isInQuestion => current.type == FlowStepType.question;
  
  // 현재 문제 인덱스 (0-based) - VM과 동기화용
  int get currentQuestionIndex {
    // 현재 단계가 question이면 해당 stage - 1, 아니면 마지막 question stage - 1
    if (current.type == FlowStepType.question) {
      return current.stage - 1;
    }
    
    // conversation이나 intro 단계인 경우, 히스토리에서 마지막 question stage 찾기
    for (int i = _history.length - 1; i >= 0; i--) {
      if (_history[i].type == FlowStepType.question) {
        return _history[i].stage - 1;
      }
    }
    
    return 0; // 기본값
  }
  
  // VM 참조를 위한 콜백
  Function(int)? _onQuestionIndexChanged;
  
  void setQuestionIndexCallback(Function(int) callback) {
    _onQuestionIndexChanged = callback;
  }
  

  void toConversation(int stage) {
    _history.add(FlowStep(FlowStepType.conversation, stage));
    notifyListeners();
  }

  void toQuestion(int stage) {
    _history.add(FlowStep(FlowStepType.question, stage));
    
    // VM의 currentIndex 동기화
    if (_onQuestionIndexChanged != null) {
      final questionIndex = stage - 1; // stage는 1-based, index는 0-based
      _onQuestionIndexChanged!(questionIndex);
    }
    
    notifyListeners();
  }

  bool popStepInternal() {
    if (_history.length <= 1) {
      return true; // 더 이상 이전 없음 → Route pop 허용
    }
    final removed = _history.removeLast();
    
    // question 단계로 돌아갈 때 VM의 currentIndex 동기화
    if (removed.type == FlowStepType.question && _onQuestionIndexChanged != null) {
      final questionIndex = removed.stage - 1; // stage는 1-based, index는 0-based
      _onQuestionIndexChanged!(questionIndex);
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
