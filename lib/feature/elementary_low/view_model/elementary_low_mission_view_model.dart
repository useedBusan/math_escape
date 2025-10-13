import '../../../core/viewmodels/base_viewmodel.dart';
import '../../../core/viewmodels/intro_view_model.dart';
import '../../../core/services/service_locator.dart';
import '../model/elementary_low_mission_model.dart';

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
  bool _showConversation = false; // Coordinator가 단계를 관리하므로 사용하지 않음
  bool _showFinalConversation = false; // 마지막 스테이지 대화를 보여줄지 여부
  
  // 현재 대화 상태 관리
  IntroViewModel? _currentConversation;
  
  // Coordinator와의 동기화를 위한 콜백
  Function(int)? _onIndexChangedCallback;

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
  bool get showConversation => _showConversation;
  bool get showFinalConversation => _showFinalConversation;
  int get totalCount => _missions.length;
  IntroViewModel? get currentConversation => _currentConversation;
  bool get hasIndexCallback => _onIndexChangedCallback != null;

  // Intents
  void selectChoice(int index) {
    final mission = currentMission;
    if (mission == null) return;
    if (index < 0 || index >= mission.choices.length) return;
    _selectedChoiceIndex = index;
    _lastSubmitCorrect = null;
    safeNotifyListeners();
  }

  Future<bool> submitAnswer() async {
    if (!isLoaded || currentMission == null) return false;
    setLoading(true);
    try {
      final mission = currentMission!;
      final String answerCandidate = _selectedChoiceIndex != null &&
          _selectedChoiceIndex! < mission.choices.length
          ? mission.choices[_selectedChoiceIndex!]
          : '';
      final ok = mission.answerIndex == _selectedChoiceIndex;
      
      setLoading(false);
      return ok;
    } catch (_) {
      setLoading(false);
      return false;
    }
  }

  // Coordinator가 호출하는 메서드 - 직접 호출하지 않음
  void setCurrentIndexByCoordinator(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      _currentConversation = null; // 이전 대화 상태 초기화
      safeNotifyListeners();
    }
  }
  
  void setFinalConversationByCoordinator(bool show) {
    _showFinalConversation = show;
    safeNotifyListeners();
  }


  void completeConversation() {
    // Coordinator가 단계를 관리하므로 여기서는 상태 변경하지 않음
    safeNotifyListeners();
  }

  void completeFinalConversation() {
    _showFinalConversation = false;
    safeNotifyListeners();
  }

  // 대화 상태 관리 메서드들
  void setCurrentConversation(IntroViewModel conversation) {
    _currentConversation = conversation;
    safeNotifyListeners();
  }

  void clearCurrentConversation() {
    _currentConversation = null;
    safeNotifyListeners();
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
  
  // Coordinator와의 동기화를 위한 메서드들
  void setIndexChangedCallback(Function(int) callback) {
    _onIndexChangedCallback = callback;
  }
  
  void syncWithCoordinator(int coordinatorIndex) {
    if (_currentIndex != coordinatorIndex) {
      _currentIndex = coordinatorIndex;
      _selectedChoiceIndex = null;
      _lastSubmitCorrect = null;
      safeNotifyListeners();
    }
  }
  
  void setCurrentIndex(int index) {
    if (index >= 0 && index < _missions.length) {
      _currentIndex = index;
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
    _showConversation = true;
    safeNotifyListeners();
  }

  // Load
  Future<void> _loadMissions() async {
    try {
      final jsonList = await serviceLocator.dataService.loadJsonList(
        'assets/data/elem_low/elem_low_question.json',
      );

      _missions
        ..clear()
        ..addAll(jsonList.map(
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