class IntegerPhaseUtils {
  static const Map<int, int> questionToPhase = {
    1: 0,  // 문제 1: 아무 한자도 없음
    2: 1,  // 문제 2: 첫 번째 한자
    3: 2,  // 문제 3: 두 번째 한자
    6: 3,  // 문제 6: 세 번째 한자
    7: 4,  // 문제 7: 네 번째 한자
  };

  static int getPhaseFromQuestionNumber(int questionNumber) {
    // 문제 번호에 따른 phase 반환
    if (questionToPhase.containsKey(questionNumber)) {
      return questionToPhase[questionNumber]!;
    }
    
    // 범위에 따른 phase 계산
    if (questionNumber <= 1) return 0;
    if (questionNumber <= 3) return 1;
    if (questionNumber <= 5) return 2;
    if (questionNumber <= 6) return 3;
    return 4; // 7번 이상
  }

  static String getPhaseText(int phase) {
    const List<String> phases = [
      '인류의 처음 **{#8352D9|정수}**의 **{#5298D9|정수}**는 한 개인의 처음 **{#D98A52|정수}**를 만들기 위해 가장 기본이 되는 것, 곧 **{#D95276|정수}**!',
      '인류의 처음 **{#8352D9|정수(整數)}**의 **{#5298D9|정수}**는 한 개인의 처음 **{#D98A52|정수}**를 만들기 위해 가장 기본이 되는 것, 곧 **{#D95276|정수}**!',
      '인류의 처음 **{#8352D9|정수(整數)}**의 **{#5298D9|정수}**는 한 개인의 처음 **{#D98A52|정수(整數)}**를 만들기 위해 가장 기본이 되는 것, 곧 **{#D95276|정수}**!',
      '인류의 처음 **{#8352D9|정수(整數)}**의 **{#5298D9|정수(精髓)}**는 한 개인의 처음 **{#D98A52|정수(整數)}**를 만들기 위해 가장 기본이 되는 것, 곧 **{#D95276|정수}**!',
      '인류의 처음 **{#8352D9|정수(整數)}**의 **{#5298D9|정수(精髓)}**는 한 개인의 처음 **{#D98A52|정수(整數)}**를 만들기 위해 가장 기본이 되는 것, 곧 **{#D95276|정수(精髓)}**!',
    ];
    
    return phases[phase.clamp(0, phases.length - 1)];
  }
}
