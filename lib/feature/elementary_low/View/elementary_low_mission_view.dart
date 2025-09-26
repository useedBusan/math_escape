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
      child: Consumer<ElementaryLowMissionViewModel>(
        builder: (ctx, vm, child) {
          // 최종 대화를 보여줘야 하는 경우
          if (vm.showFinalConversation) {
            return _ConversationView(
              stage: 7, // 마지막 스테이지
              onComplete: () {
                vm.completeFinalConversation();
                // 최종 대화 완료 후 메인 화면으로 돌아가거나 다른 처리
                Navigator.of(ctx).pop();
              },
            );
          }
          
          // 일반 대화를 보여줘야 하는 경우
          if (vm.showConversation) {
            return _ConversationView(
              stage: vm.currentIndex + 1,
              onComplete: () {
                vm.completeConversation();
              },
            );
          }
          
          return MissionBackgroundView(
          grade: grade,
          title: '미션! 수사모의 수학 보물을 찾아서',
          missionBuilder: (_) => const ElementaryLowMissionListView(),
          isqr: vm.isqr,

            // 힌트 팝업
            hintDialogueBuilder: (_) {
              final mission = vm.currentMission;
              if (mission == null) return const SizedBox.shrink();

              final hintVM = ctx.read<HintPopupViewModel>();
              final hints = mission.hints;
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
              await vm.submitAnswer();
              return vm.lastSubmitCorrect ?? false;
            },

            onCorrect: () async {
              vm.nextMission();
              ctx.read<HintPopupViewModel>().reset();
            },
          );
        },
      ),
    );
  }
}

// 대화 시퀀스를 관리하는 전용 위젯
class _ConversationView extends StatefulWidget {
  final int stage;
  final VoidCallback onComplete;

  const _ConversationView({
    required this.stage,
    required this.onComplete,
  });

  @override
  State<_ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<_ConversationView> {
  late IntroViewModel viewModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    try {
      viewModel = IntroViewModel();
      await viewModel.loadTalks('assets/data/elem_low/elem_low_conversation.json');
      viewModel.setStageTalks(widget.stage);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.talks.isEmpty) {
      // 대화가 없으면 바로 완료 처리
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete();
      });
      return const SizedBox.shrink();
    }

    return ChangeNotifierProvider.value(
      value: viewModel,
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
                widget.onComplete();
              }
            },
          );
        },
      ),
    );
  }
}