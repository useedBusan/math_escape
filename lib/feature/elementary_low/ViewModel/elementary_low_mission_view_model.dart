import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/utils/view_model/base_viewmodel.dart';
import '../Model/elementary_low_mission_model.dart';

class ElementaryLowMissionViewModel extends BaseViewModel {
  ElementaryLowMissionViewModel() {
    _loadMissions();
  }

  // State
  final List<ElementaryLowMissionModel> _missions = [];
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  bool? _lastSubmitCorrect;
  bool _loaded = false;

  // Getters
  List<ElementaryLowMissionModel> get missions => List.unmodifiable(_missions);
  int get currentIndex => _currentIndex;
  ElementaryLowMissionModel? get currentMission =>
      _missions.isEmpty ? null : _missions[_currentIndex];
  int? get selectedChoiceIndex => _selectedChoiceIndex;
  double get progress {
    final total = _missions.length;
    if (total == 0) return 0.0;
    final done = (_currentIndex + 1);
    return (done / total).clamp(0.0, 1.0);
  }
  bool get canSubmit => _selectedChoiceIndex != null && !isLoading;
  bool? get lastSubmitCorrect => _lastSubmitCorrect;
  bool get isLoaded => _loaded;
  bool get isqr => currentMission?.isqr ?? false;

  // Intents
  void selectChoice(int index) {
    final mission = currentMission;
    if (mission == null) return;
    if (index < 0 || index >= mission.choices.length) return;
    _selectedChoiceIndex = index;
    _lastSubmitCorrect = null;
    safeNotifyListeners();
  }

  Future<void> submitAnswer() async {
    if (!canSubmit || currentMission == null) return;
    setLoading(true);
    try {
      final correctIndex = currentMission!.answerIndex;
      _lastSubmitCorrect = (_selectedChoiceIndex == correctIndex);
      await Future<void>.delayed(const Duration(milliseconds: 150));
    } catch (_) {
      setError('정답 확인 중 오류가 발생했어요.');
    } finally {
      setLoading(false);
    }
  }

  void nextMission() {
    if (_missions.isEmpty) return;
    if (_currentIndex < _missions.length - 1) {
      _currentIndex++;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      safeNotifyListeners();
    }
  }

  void previousMission() {
    if (_missions.isEmpty) return;
    if (_currentIndex > 0) {
      _currentIndex--;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      safeNotifyListeners();
    }
  }

  /// 화면 빠져나갈 때 초기화가 필요하면 외부에서 호출
  void reset() {
    _missions.clear();
    _currentIndex = 0;
    _selectedChoiceIndex = null;
    _lastSubmitCorrect = null;
    _loaded = false;
    safeNotifyListeners();
  }

  // Load
  Future<void> _loadMissions() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/data/elem_low/elem_low_question.json',
      );
      final list = json.decode(jsonStr) as List<dynamic>;

      _missions
        ..clear()
        ..addAll(list.map(
              (e) => ElementaryLowMissionModel.fromJson(e as Map<String, dynamic>),
        ));

      // 방어적으로 인덱스 초기화
      _currentIndex = 0;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      _loaded = true;
      safeNotifyListeners();
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
            hints:[],
            questionImage: null,
          ),
        );
      _loaded = true;
      setError('미션 데이터 로딩 실패');
      safeNotifyListeners();
    }
  }
}