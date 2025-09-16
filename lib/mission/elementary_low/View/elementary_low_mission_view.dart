import 'package:flutter/material.dart';
import 'package:math_escape/Common/Enums/grade_enums.dart';
import 'package:math_escape/Common/View/mission_background_view.dart';
import 'package:math_escape/Common/View/temporary_elementary_hint_dialogue.dart';
import 'package:provider/provider.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';
import 'elementary_low_mission_list_view.dart';

class ElementaryLowMissionView extends StatefulWidget {
  const ElementaryLowMissionView({super.key});

  @override
  State<ElementaryLowMissionView> createState() =>
      _ElementaryLowMissionViewState();
}

class _ElementaryLowMissionViewState extends State<ElementaryLowMissionView> {
  final StudentGrade grade = StudentGrade.elementaryLow;

  Widget missionBuilder(BuildContext context) {
    return ElementaryLowMissionListView();
  }

  Widget hintDialogueBuilder(BuildContext context) {
    return const TemporaryElementaryHintDialogue();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ElementaryLowMissionViewModel(),
      child: Builder(
        builder: (ctx) => MissionBackgroundView(
          grade: grade,
          title: "미션! 수사모의 수학 보물을 찾아서",
          missionBuilder: (_) => const ElementaryLowMissionListView(),
          hintDialogueBuilder: (_) => const TemporaryElementaryHintDialogue(),
          onSubmitAnswer: (c) async {
            final vm = c.read<ElementaryLowMissionViewModel>();
            await vm.submitAnswer();
            return vm.lastSubmitCorrect ?? false;
          },
          onCorrect: () => ctx.read<ElementaryLowMissionViewModel>().nextMission(),
        ),
      ),
    );
  }
}
