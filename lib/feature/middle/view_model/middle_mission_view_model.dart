import 'package:flutter/material.dart';
import '../../../core/services/service_locator.dart';
import '../model/middle_mission_model.dart';

enum MiddleMissionState {
  conversation, // 대화 중
  question,     // 문제 중
}

class MiddleMissionViewModel extends ChangeNotifier {
  final List<MissionItem> _missions = [];
  final List<CorrectTalkItem> _talks = [];
  
  // 현재 상태 관리
  MiddleMissionState _currentState = MiddleMissionState.conversation;
  int _currentIndex = 0; // 0-based 인덱스
  
  final TextEditingController _answerController = TextEditingController();
  final FocusNode answerFocusNode = FocusNode();
  int _hintCounter = 0;
  bool _showHint1 = false;
  bool _showHint2 = false;
  bool _isLoading = true;

  // Getters
  List<MissionItem> get missions => List.unmodifiable(_missions);
  List<CorrectTalkItem> get talks => List.unmodifiable(_talks);
  int get currentIndex => _currentIndex;
  MiddleMissionState get currentState => _currentState;
  MissionItem? get currentMission => _missions.isEmpty ? null : _missions[_currentIndex];
  TextEditingController get answerController => _answerController;
  int get hintCounter => _hintCounter;
  bool get showHint1 => _showHint1;
  bool get showHint2 => _showHint2;
  bool get isLoading => _isLoading;
  bool get isqr => currentMission?.isqr ?? false;
  bool get isInConversation => _currentState == MiddleMissionState.conversation;
  bool get isInQuestion => _currentState == MiddleMissionState.question;
  
  int get totalCount => _missions.length;
  
  double get progress {
    final total = _missions.length;
    if (total == 0) return 0.0;
    final done = (_currentIndex + 1);
    return (done / total).clamp(0.0, 1.0);
  }

  Future<void> loadMissionData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // DataService를 사용하여 미션 데이터와 대화 데이터를 병렬로 로드
      final missionData = await serviceLocator.dataService.loadMissionData('middle');
      
      final List<dynamic> missionJsonList = missionData['missions'];
      final List<dynamic> talkJsonList = missionData['talks'];

      _missions
        ..clear()
        ..addAll(missionJsonList.map((e) => MissionItem.fromJson(e)));
        
      _talks
        ..clear()
        ..addAll(talkJsonList.map((e) => CorrectTalkItem.fromJson(e)));
        
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void showHintDialog() {
    _hintCounter++;
    
    switch (_hintCounter) {
      case 1:
        _showHint1 = true;
        break;
      case 2:
        _showHint2 = true;
        break;
      default:
        _hintCounter = 0;
        _showHint1 = false;
        _showHint2 = false;
    }
    notifyListeners();
  }

  Future<bool> submitAnswer() async {
    final currentMission = this.currentMission;
    if (currentMission == null) return false;
    
    final String userAnswer = _answerController.text.trim();
    final bool correct = currentMission.answer.contains(userAnswer);
    
    return correct;
  }

  // QR 답변 검증
  bool validateQRAnswer(String scannedValue) {
    final currentMission = this.currentMission;
    if (currentMission == null) return false;
    
    return currentMission.validateQRAnswer(scannedValue);
  }

  // 상태 전환 메서드들
  void goToConversation(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
      _currentState = MiddleMissionState.conversation;
      _resetQuestionState();
      notifyListeners();
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
      _currentState = MiddleMissionState.question;
      _resetQuestionState();
      notifyListeners();
    }
  }

  // 문제 완료 후 다음 대화로 이동
  void completeQuestion() {
    if (_currentIndex < _missions.length - 1) {
      // 다음 문제의 대화로 이동
      goToConversation(_currentIndex + 1);
    } else {
      // 모든 문제 완료 - 종료 처리
      notifyListeners();
    }
  }

  // 뒤로가기 로직
  bool handleBack() {
    if (_currentState == MiddleMissionState.question) {
      // 문제에서 뒤로가기 → 같은 인덱스의 대화로
      goToConversation(_currentIndex);
      return true;
    } else if (_currentState == MiddleMissionState.conversation) {
      // 대화에서 뒤로가기 → 이전 인덱스의 문제로
      if (_currentIndex > 0) {
        goToQuestion(_currentIndex - 1);
        return true;
      } else {
        // 첫 번째 대화에서 뒤로가기 → HomeAlert 필요
        return false;
      }
    }
    return false;
  }

  void _resetQuestionState() {
    _answerController.clear();
    _hintCounter = 0;
    _showHint1 = false;
    _showHint2 = false;
  }

  @override
  void dispose() {
    _answerController.dispose();
    answerFocusNode.dispose();
    super.dispose();
  }
}
