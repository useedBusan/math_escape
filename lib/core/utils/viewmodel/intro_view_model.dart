import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../model/talk_model.dart';

/// 공통 인트로 화면에서 재사용 가능한 간단 ViewModel
class IntroViewModel extends ChangeNotifier {
  List<Talk> talks = [];
  int currentIdx = 0;

  bool canGoNext() => currentIdx < talks.length - 1;
  bool canGoPrevious() => currentIdx > 0;

  Future<void> loadTalks(String assetJsonPath) async {
    final String jsonString = await rootBundle.loadString(assetJsonPath);
    final List<dynamic> jsonList = json.decode(jsonString);
    talks = jsonList.map((json) => Talk.fromJson(json)).toList();
    notifyListeners();
  }

  Talk get currentTalk => talks[currentIdx];

  void goToNextTalk() {
    if (canGoNext()) {
      currentIdx++;
      notifyListeners();
    }
  }

  void goToPreviousTalk() {
    if (canGoPrevious()) {
      currentIdx--;
      notifyListeners();
    }
  }

  // 특정 stage의 대화만 필터링
  void setStageTalks(int stage) {
    final originalTalks = List<Talk>.from(talks);
    talks = originalTalks.where((talk) => talk.stage == stage).toList();
    currentIdx = 0;
    notifyListeners();
  }
}


