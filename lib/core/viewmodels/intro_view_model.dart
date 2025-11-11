import 'package:flutter/material.dart';
import '../models/talk_model.dart';
import '../services/service_locator.dart';

/// 공통 인트로 화면에서 재사용 가능한 간단 view_model
class IntroViewModel extends ChangeNotifier {
  List<Talk> talks = [];
  int currentIdx = 0;

  bool canGoNext() => currentIdx < talks.length - 1;
  bool canGoPrevious() => currentIdx > 0;
  
  Talk get currentTalk => talks[currentIdx];

  Future<void> loadTalks(String assetJsonPath) async {
    try {
      final jsonList = await serviceLocator.dataService.loadJsonList(assetJsonPath);
      talks = jsonList.map((json) => Talk.fromJson(json)).toList();
      // 자동 재생 제거 - setStageTalks()에서만 재생하도록
      notifyListeners();
    } catch (e) {
      // 에러 처리
      talks = [];
      notifyListeners();
    }
  }

  int getMaxStage() {
    if (talks.isEmpty) return 0;
    return talks
        .where((talk) => talk.stage != null)
        .map((talk) => talk.stage!)
        .reduce((a, b) => a > b ? a : b);
  }

  void goToNextTalk() {
    if (canGoNext()) {
      currentIdx++;
      _playCurrentVoice();
      notifyListeners();
    }
  }

  void goToPreviousTalk() {
    if (canGoPrevious()) {
      currentIdx--;
      _playCurrentVoice();
      notifyListeners();
    }
  }

  // 특정 stage의 대화만 필터링
  void setStageTalks(int stage) {
    final originalTalks = List<Talk>.from(talks);
    talks = originalTalks.where((talk) => talk.stage == stage).toList();
    currentIdx = 0;
    _playCurrentVoice();
    notifyListeners();
  }

  void _playCurrentVoice() {
    if (talks.isEmpty) {
      return;
    }
    final String? voice = talks[currentIdx].voice;
    if (voice == null || voice.isEmpty) {
      // 보이스가 없으면 중단
      serviceLocator.audioService.stopCharacter();
      return;
    }
    serviceLocator.audioService.playCharacterAudio(voice);
  }

  @override
  void dispose() {
    // 화면 종료 시 캐릭터 보이스 중단
    serviceLocator.audioService.stopCharacter();
    super.dispose();
  }
}


