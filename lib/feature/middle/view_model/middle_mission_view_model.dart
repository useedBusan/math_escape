import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/utils/viewmodel/intro_view_model.dart';
import '../model/middle_mission_model.dart';

class MiddleMissionViewModel extends ChangeNotifier {
  final List<MissionItem> _missions = [];
  final List<CorrectTalkItem> _talks = [];
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  int _hintCounter = 0;
  bool _showHint1 = false;
  bool _showHint2 = false;
  bool _isLoading = true;
  bool _showFinalConversation = false; // 마지막 스테이지 대화를 보여줄지 여부
  
  // 대화 히스토리 관리
  List<IntroViewModel> _conversationHistory = [];
  
  // Coordinator와의 동기화를 위한 콜백
  Function(int)? _onIndexChangedCallback;

  // Getters
  List<MissionItem> get missions => List.unmodifiable(_missions);
  List<CorrectTalkItem> get talks => List.unmodifiable(_talks);
  int get currentIndex => _currentIndex;
  MissionItem? get currentMission => _missions.isEmpty ? null : _missions[_currentIndex];
  TextEditingController get answerController => _answerController;
  int get hintCounter => _hintCounter;
  bool get showHint1 => _showHint1;
  bool get showHint2 => _showHint2;
  bool get isLoading => _isLoading;
  bool get isqr => currentMission?.isqr ?? false;
  bool get showFinalConversation => _showFinalConversation;
  List<IntroViewModel> get conversationHistory => List.unmodifiable(_conversationHistory);
  bool get hasIndexCallback => _onIndexChangedCallback != null;
  
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
      final String missionJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_question.json',
      );
      final List<dynamic> missionJsonList = json.decode(missionJsonString);

      final String talkJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_conversation.json',
      );
      final List<dynamic> talkJsonList = json.decode(talkJsonString);

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

  void goToNextQuestion() {
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      _answerController.clear();
      _hintCounter = 0;
      _showHint1 = false;
      _showHint2 = false;
      
      // 대화 히스토리 정리 (현재 문제 이전의 대화들은 유지)
      _conversationHistory = _conversationHistory.where((conv) {
        final questionId = conv.talks.first.id ~/ 100;
        return questionId <= _currentIndex;
      }).toList();
      
      // Coordinator에 인덱스 변경 알림
      if (_onIndexChangedCallback != null) {
        _onIndexChangedCallback!(_currentIndex);
      }
      
      notifyListeners();
    }
  }

  void goToPreviousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _answerController.clear();
      _hintCounter = 0;
      _showHint1 = false;
      _showHint2 = false;
      notifyListeners();
    }
  }

  void addConversationToHistory(IntroViewModel conversation) {
    _conversationHistory.add(conversation);
  }

  IntroViewModel? getLastConversation() {
    if (_conversationHistory.isEmpty) return null;
    return _conversationHistory.removeLast();
  }

  void clearAnswer() {
    _answerController.clear();
    notifyListeners();
  }

  // Coordinator와의 동기화를 위한 메서드들
  void setIndexChangedCallback(Function(int) callback) {
    _onIndexChangedCallback = callback;
  }
  
  void syncWithCoordinator(int coordinatorIndex) {
    if (_currentIndex != coordinatorIndex) {
      _currentIndex = coordinatorIndex;
      _answerController.clear();
      _hintCounter = 0;
      _showHint1 = false;
      _showHint2 = false;
      notifyListeners();
    }
  }
  
  void setCurrentIndex(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
      _answerController.clear();
      _hintCounter = 0;
      _showHint1 = false;
      _showHint2 = false;
      notifyListeners();
    }
  }

  // Coordinator가 호출하는 메서드들
  void setFinalConversationByCoordinator(bool show) {
    _showFinalConversation = show;
    notifyListeners();
  }

  void completeFinalConversation() {
    _showFinalConversation = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
