import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../Model/elementary_low_mission_model.dart';


class ElementaryLowMissionViewModel extends ChangeNotifier {
  ElementaryLowMissionViewModel._internal() {
    _loadMissions();
  }
  static final ElementaryLowMissionViewModel instance =
  ElementaryLowMissionViewModel._internal();

  // ---------------- State ----------------
  final List<ElementaryLowMissionModel> _missions = [];
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  bool _isSubmitting = false;
  bool? _lastSubmitCorrect;
  bool _loaded = false;

  // ---------------- Getters ----------------
  List<ElementaryLowMissionModel> get missions => List.unmodifiable(_missions);
  int get currentIndex => _currentIndex;
  ElementaryLowMissionModel? get currentMission =>
      _missions.isEmpty ? null : _missions[_currentIndex];

  int? get selectedChoiceIndex => _selectedChoiceIndex;
  bool get canSubmit => _selectedChoiceIndex != null && !_isSubmitting;
  bool get isSubmitting => _isSubmitting;
  bool? get lastSubmitCorrect => _lastSubmitCorrect;
  bool get isLoaded => _loaded;

  // ---------------- Intents ----------------
  void selectChoice(int index) {
    final mission = currentMission;
    if (mission == null) return;
    if (index < 0 || index >= mission.choices.length) return;
    _selectedChoiceIndex = index;
    _lastSubmitCorrect = null;
    notifyListeners();
  }

  Future<void> submitAnswer() async {
    if (!canSubmit || currentMission == null) return;
    _isSubmitting = true;
    notifyListeners();

    try {
      final int correctIndex = currentMission!.answerIndex;
      _lastSubmitCorrect = (_selectedChoiceIndex == correctIndex);
      await Future<void>.delayed(const Duration(milliseconds: 150));
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void nextMission() {
    if (_missions.isEmpty) return;
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      notifyListeners();
    }
  }

  void previousMission() {
    if (_missions.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      notifyListeners();
    }
  }

  // ---------------- Load ----------------
  Future<void> _loadMissions() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'assets/data/elementary_low/elementary_low_questions.json',
      );
      final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;

      _missions
        ..clear()
        ..addAll(
          list.map((e) => ElementaryLowMissionModel.fromJson(e as Map<String, dynamic>)),
        );

      _loaded = true;
      notifyListeners();
    } catch (e) {
      _missions
        ..clear()
        ..add(
          ElementaryLowMissionModel(
            id: 0,
            title: '문제 로딩 실패',
            question: '에셋 JSON을 불러오지 못했습니다..',
            choices: const ['확인함', '나중에'],
            answerIndex: 0,
            hint1: '힌트1',
            hint2: '힌트2',
            questionImage: null,
          ),
        );
      _loaded = true;
      notifyListeners();
    }
  }
}