import "dart:convert";
import "package:flutter/services.dart";
import "../../../models/elementary_low/talk_model.dart";

class ElementaryLowIntroViewModel {
  List<Talk> talks = [];
  int currentIdx = 0;

  bool canGoNext() => currentIdx < talks.length - 1;
  bool canGoPrevious() => currentIdx > 0;

  Future<void> loadTalks() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/elementary_low/elementary_low_intro_view.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    talks = jsonList.map((json) => Talk.fromJson(json)).toList();
  }

  Talk get currentTalk => talks[currentIdx];

  void goToNextTalk() {
    if (canGoNext()) {
      currentIdx++;
    }
  }

  void goToPreviousTalk() {
    if (canGoPrevious()) {
      currentIdx--;
    }
  }
}
