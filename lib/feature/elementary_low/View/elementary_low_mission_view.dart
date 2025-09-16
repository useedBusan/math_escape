import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import 'elementary_low_mission_list_view.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';

class ElementaryLowMissionView extends StatelessWidget {
  const ElementaryLowMissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ElementaryLowMissionViewModel()),
        ChangeNotifierProvider(create: (_) => HintPopupViewModel()),
      ],
      child: Builder(
        builder: (ctx) {
          const grade = StudentGrade.elementaryLow;

          return MissionBackgroundView(
            grade: grade,
            title: "미션! 수사모의 수학 보물을 찾아서",
            missionBuilder: (_) => const ElementaryLowMissionListView(),
            hintDialogueBuilder: (_) {
              final vm = ctx.read<ElementaryLowMissionViewModel>();
              final hintVM = ctx.read<HintPopupViewModel>();

              final mission = vm.currentMission;
              if (mission == null) {
                return const SizedBox.shrink();
              }

              final step = hintVM.consumeNextStep();
              final hintText = (step == 1) ? mission.hint1 : mission.hint2;

              final model = hintVM.buildModel(
                grade: grade,
                step: step,
                hintText: hintText,
              );

              return HintPopup(
                model: model,
                onConfirm: () => Navigator.of(ctx).pop(),
              );
            },

            onSubmitAnswer: (c) async {
              final vm = c.read<ElementaryLowMissionViewModel>();
              await vm.submitAnswer();
              return vm.lastSubmitCorrect ?? false;
            },
            onCorrect: () {
              // 다음 문제로 넘어갈 때 힌트 스텝 리셋
              ctx.read<ElementaryLowMissionViewModel>().nextMission();
              ctx.read<HintPopupViewModel>().reset();
            },
          );
        },
      ),
    );
  }
}