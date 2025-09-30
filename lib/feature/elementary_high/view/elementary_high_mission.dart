import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/image_enums.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../../../core/utils/viewmodel/intro_view_model.dart';
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
        ChangeNotifierProvider(create: (_) =>
        ElementaryHighMissionViewModel()
          ..load('assets/data/elem_high/elem_high_question.json')),
        ChangeNotifierProvider(create: (_) => HintPopupViewModel()),
      ],
      child: Consumer<ElementaryHighMissionViewModel>(
        builder: (context, vm, child) {
          // 최종 대화를 보여줘야 하는 경우
          if (vm.showFinalConversation) {
            return _ConversationView(
              stage: vm.totalCount, // 마지막 스테이지
              onComplete: () {
                vm.completeFinalConversation();
                // 최종 대화 완료 후 메인 화면으로 돌아가거나 다른 처리
                Navigator.of(context).pop();
              },
            );
          }
          
          // 일반 대화는 정답팝업 후에 표시되므로 여기서는 제거
          
          return MissionBackgroundView(
            grade: grade,
            title: '미션! 수사모의 수학 보물을 찾아서',
            missionBuilder: (_) => const ElementaryHighMissionListView(),
            isqr: vm.isqr,
            hintDialogueBuilder: (_) {
              final mission = vm.currentMission;
              if (mission == null) return const SizedBox.shrink();

              final hintVM = context.read<HintPopupViewModel>();
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
                onConfirm: () => Navigator.of(context).pop(),
              );
            },
            onSubmitAnswer: (c) async {
              return await vm.submitAnswer();
            },
            onCorrect: () async {
              // 정답 후 대화 표시 → stage 기반으로 대화 찾기
              final int currentStage = vm.currentIndex + 1; // 1-based stage
              print('DEBUG: onCorrect called, currentStage=$currentStage');
              await Navigator.push(context, MaterialPageRoute(builder: (_) {
                return _ConversationView(
                  stage: currentStage,
                  onComplete: () {
                    print('DEBUG: Conversation completed');
                    Navigator.of(context).pop();
                    // 대화 종료 후 다음 문제 이동
                    vm.nextMission();
                    context.read<HintPopupViewModel>().reset();
                  },
                );
              }));
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
      await viewModel.loadTalks('assets/data/elem_high/elem_high_conversation.json');
      viewModel.setStageTalks(widget.stage);
      print('DEBUG: Conversation loaded for stage ${widget.stage}, talks count: ${viewModel.talks.length}');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading conversation: $e');
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
            grade: StudentGrade.elementaryHigh,
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