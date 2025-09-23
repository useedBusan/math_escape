import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/model/hint_model.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';
import 'elementary_low_mission_list_view.dart';

class ElementaryLowMissionView extends StatelessWidget {
  const ElementaryLowMissionView({super.key});

  @override
  Widget build(BuildContext context) {
    const grade = StudentGrade.elementaryLow;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ElementaryLowMissionViewModel()),
        ChangeNotifierProvider(create: (_) => HintPopupViewModel()),
      ],
      child: Builder(
        builder: (ctx) {
          return MissionBackgroundView(
            grade: grade,
            title: '미션! 수사모의 수학 보물을 찾아서',
            missionBuilder: (_) => const ElementaryLowMissionListView(),

            // 힌트 팝업
            hintDialogueBuilder: (_) {
              final mission =
                  ctx.read<ElementaryLowMissionViewModel>().currentMission;
              if (mission == null) return const SizedBox.shrink();

              final hintVM = ctx.read<HintPopupViewModel>();
              final List<HintEntry> hints = mission.hints;
              hintVM.setHints(hints);
              final content = hintVM.consumeNext();
              if (content == null) return const SizedBox.shrink();

              final model = hintVM.buildModel(
                grade: grade,
                content: content,
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
              ctx.read<ElementaryLowMissionViewModel>().nextMission();
              ctx.read<HintPopupViewModel>().reset();
            },
          );
        },
      ),
    );
  }
}