import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/model/hint_model.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';
import 'elementary_low_mission_list_view.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/utils/view/common_intro_view.dart';
import '../../../core/utils/viewmodel/intro_view_model.dart'; // For IntroViewModel
import '../../../constants/enum/speaker_enums.dart';
import '../../../constants/enum/image_enums.dart'; // For Speaker enum

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
          isqr: ctx.read<ElementaryLowMissionViewModel>().isqr,

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

            onCorrect: () async {
              final vm = ctx.read<ElementaryLowMissionViewModel>();
              final int currentStage = vm.currentIndex + 1; // 1-based stage
              
              try {
                // IntroViewModel을 사용해서 대화 시퀀스 관리
                final conversationVM = IntroViewModel();
                await conversationVM.loadTalks('assets/data/elem_low/elem_low_conversation.json');
                
                // 현재 stage의 대화만 필터링
                conversationVM.setStageTalks(currentStage);
                
                if (conversationVM.talks.isNotEmpty) {
                  Navigator.push(ctx, MaterialPageRoute(builder: (_) {
                    return _ConversationView(
                      viewModel: conversationVM,
                      onComplete: () {
                        Navigator.of(ctx).pop();
                        vm.nextMission();
                        ctx.read<HintPopupViewModel>().reset();
                      },
                    );
                  }));
                } else {
                  vm.nextMission();
                  ctx.read<HintPopupViewModel>().reset();
                }
              } catch (_) {
                vm.nextMission();
                ctx.read<HintPopupViewModel>().reset();
              }
            },
          );
        },
      ),
    );
  }
}

// 대화 시퀀스를 관리하는 전용 위젯
class _ConversationView extends StatefulWidget {
  final IntroViewModel viewModel;
  final VoidCallback onComplete;

  const _ConversationView({
    required this.viewModel,
    required this.onComplete,
  });

  @override
  State<_ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<_ConversationView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<IntroViewModel>(
        builder: (context, vm, child) {
          final talk = vm.currentTalk;
          
          String speakerName() {
            switch (talk.speaker) {
              case Speaker.puri:
                return "푸리";
              case Speaker.maemae:
                return "매매";
              case Speaker.book:
                return "수첩";
              default:
                return "";
            }
          }

          return CommonIntroView(
            appBarTitle: "미션! 수사모의 수학 보물을 찾아서",
            backgroundAssetPath: talk.backImg,
            characterImageAssetPath: talk.speakerImg,
            speakerName: speakerName(),
            talkText: talk.talk,
            buttonText: "다음",
            grade: StudentGrade.elementaryLow,
            onNext: () {
              if (vm.canGoNext()) {
                vm.goToNextTalk();
              } else {
                widget.onComplete();
              }
            },
            onBack: () {
              if (vm.canGoPrevious()) {
                vm.goToPreviousTalk();
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        },
      ),
    );
  }
}