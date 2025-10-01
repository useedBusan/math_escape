import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/elementary_high_mission_model.dart';

class ElementaryHighMissionViewModel extends ChangeNotifier {
  final List<ElementaryHighMissionModel> _missions = [];
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  int get totalCount => _missions.length;
  bool _isLoading = true;
  bool _isBusy = false;
  String _typedAnswer = '';
  final TextEditingController textController = TextEditingController();
  bool _showConversation = true; // 첫 번째 문제 전에 대화를 보여줄지 여부
  bool _showFinalConversation = false; // 마지막 스테이지 대화를 보여줄지 여부
  
  // Coordinator와의 동기화를 위한 콜백
  Function(int)? _onIndexChangedCallback;
  
  bool get hasIndexCallback => _onIndexChangedCallback != null;

  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  bool get hasMission => _missions.isNotEmpty;
  int? get selectedChoiceIndex => _selectedChoiceIndex;
  String get typedAnswer => _typedAnswer;
  int get currentIndex => _currentIndex;

  ElementaryHighMissionModel? get currentMission =>
      hasMission ? _missions[_currentIndex] : null;

  double get progress =>
      hasMission ? (_currentIndex + 1) / _missions.length : 0;

  bool get isqr => currentMission?.isqr ?? false;
  bool get showConversation => _showConversation;
  bool get showFinalConversation => _showFinalConversation;

  Future<void> load(String assetPath) async {
    _isLoading = true;
    notifyListeners();
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonList = json.decode(jsonString);
    _missions
      ..clear()
      ..addAll(jsonList.map((e) => ElementaryHighMissionModel.fromJson(e)));
    _isLoading = false;
    _showFinalConversation = false;
    textController.removeListener(_onTextChanged);
    textController.addListener(_onTextChanged);
    notifyListeners();
  }

  void _onTextChanged() {
    _typedAnswer = textController.text;
  }

  void selectChoice(int index) {
    _selectedChoiceIndex = index;
    notifyListeners();
  }

  void setTypedAnswer(String value) {
    _typedAnswer = value;
    if (textController.text != value) {
      textController.text = value;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length),
      );
    }
    notifyListeners();
  }

  Future<bool> submitAnswer() async {
    if (!hasMission) return false;
    _isBusy = true;
    notifyListeners();

    final mission = currentMission!;
    final String answerCandidate = _typedAnswer.trim().isNotEmpty
        ? _typedAnswer.trim()
        : (_selectedChoiceIndex != null &&
        _selectedChoiceIndex! < mission.choices.length
        ? mission.choices[_selectedChoiceIndex!]
        : '');
    final ok = mission.answer.contains(answerCandidate);

    _isBusy = false;
    notifyListeners();
    return ok;
  }

  void nextMission() {
    if (!hasMission) return;
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      _selectedChoiceIndex = null;
      _typedAnswer = '';
      textController.clear();
      
      // Coordinator에 인덱스 변경 알림
      if (_onIndexChangedCallback != null) {
        _onIndexChangedCallback!(_currentIndex);
      }
      
      notifyListeners();
    } else {
      // 마지막 문제를 완료했을 때 최종 대화 표시
      _showFinalConversation = true;
      notifyListeners();
    }
  }

  void completeConversation() {
    _showConversation = false;
    notifyListeners();
  }

  void completeFinalConversation() {
    _showFinalConversation = false;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
      _selectedChoiceIndex = null;
      _typedAnswer = '';
      textController.clear();
      notifyListeners();
    }
  }
  
  // Coordinator와의 동기화를 위한 메서드들
  void setIndexChangedCallback(Function(int) callback) {
    _onIndexChangedCallback = callback;
  }
  
  void syncWithCoordinator(int coordinatorIndex) {
    if (_currentIndex != coordinatorIndex) {
      setCurrentIndex(coordinatorIndex);
    }
  }


  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }
}