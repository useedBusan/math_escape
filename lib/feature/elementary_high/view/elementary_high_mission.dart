import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/image_enums.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../view_model/elementary_high_mission_view_model.dart';
import 'elementary_high_mission_list_view.dart';
import '../../../core/utils/view/common_intro_view.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


class ElementaryHighMissionScreen extends StatelessWidget {
  const ElementaryHighMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const grade = StudentGrade.elementaryHigh;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ElementaryHighMissionViewModel()..load('assets/data/elem_high/elem_high_question.json')),
        ChangeNotifierProvider(create: (_) => HintPopupViewModel()),
      ],
      child: Builder(
        builder: (ctx) {
        return MissionBackgroundView(
          grade: grade,
          title: '미션! 수사모의 수학 보물을 찾아서',
          missionBuilder: (_) => const ElementaryHighMissionListView(),
          isqr: ctx.read<ElementaryHighMissionViewModel>().isqr,
          hintDialogueBuilder: (_) {
            final mission = ctx.read<ElementaryHighMissionViewModel>().currentMission;
            if (mission == null) return const SizedBox.shrink();

            final hintVM = ctx.read<HintPopupViewModel>();
            final hints = mission.hintModel.hints;

            if (hints.isEmpty) return const SizedBox.shrink();

            // 힌트가 설정되지 않았으면 설정하고 첫 번째 힌트로 이동
            if (hintVM.total == 0) {
              hintVM.setHints(hints);
            }

            // 다음 힌트 가져오기 (순환)
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
              final vm = c.read<ElementaryHighMissionViewModel>();
              return await vm.submitAnswer();
            },
            onCorrect: () async {
              // 정답 후 대화 표시 → JSON 로드 후 CommonIntroView로 푸시
              final vm = ctx.read<ElementaryHighMissionViewModel>();
              final int nextQuestionId = vm.currentIndex + 1; // 1-based
              final String talkJson = await rootBundle.loadString('assets/data/elem_high/elem_high_conversation.json');
              final List<dynamic> talks = json.decode(talkJson);
              // id 매칭 단일 talk 찾기 (elemlow/middle 구조는 별도 처리)
              final Map<String, dynamic>? talk = talks.cast<Map<String, dynamic>?>().firstWhere(
                    (e) => e != null && e['id'] == nextQuestionId,
                orElse: () => null,
              );
              if (talk != null) {
                await Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                  return CommonIntroView(
                    appBarTitle: '미션! 수사모의 수학 보물을 찾아서',
                    backgroundAssetPath: (talk['back_image'] as String?) ?? ImageAssets.background.path,
                    characterImageAssetPath: (talk['puri_image'] as String?) ?? ImageAssets.furiStanding.path,
                    speakerName: '푸리',
                    talkText: (talk['talk'] as String?) ?? '',
                    buttonText: (talk['answer'] as String?) ?? '확인',
        grade: StudentGrade.elementaryHigh,
                    onNext: () => Navigator.of(ctx).pop(),
                    onBack: () => Navigator.of(ctx).pop(),
                  );
                }));
              }
              // 대화 종료 후 다음 문제 이동
              vm.nextMission();
              ctx.read<HintPopupViewModel>().reset();
            },
          );
        },
      ),
    );
  }
}