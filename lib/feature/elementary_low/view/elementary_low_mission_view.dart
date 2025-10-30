import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/hint_popup.dart';
import '../../../core/views/outro_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../../../core/views/mission_background_view.dart';
import '../../../core/viewmodels/hint_popup_view_model.dart';
import '../view_model/elementary_low_mission_view_model.dart';
import 'elementary_low_mission_list_view.dart';
import 'conversation_overlay.dart';
import '../coordinator/elementary_low_mission_coordinator.dart';

class ElementaryLowMissionView extends StatelessWidget {
  const ElementaryLowMissionView({super.key});

  @override
  Widget build(BuildContext context) {
    const grade = StudentGrade.elementaryLow;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ElementaryLowMissionViewModel()),
        ChangeNotifierProvider(create: (_) => HintPopupViewModel()),
        ChangeNotifierProvider(create: (_) => ElementaryLowMissionCoordinator()),
      ],
      child: Consumer2<ElementaryLowMissionViewModel, ElementaryLowMissionCoordinator>(
        builder: (ctx, vm, coordinator, child) {
          coordinator.setViewModel(vm);
          
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                coordinator.handleBack();
              }
            },
            child: _buildCurrentStep(ctx, vm, coordinator, grade),
          );
        },
      ),
    );
  }
  
  Widget _buildCurrentStep(
      BuildContext context,
      ElementaryLowMissionViewModel vm,
      ElementaryLowMissionCoordinator coordinator,
      StudentGrade grade) {
    // vm.showFinalConversation는 더 이상 즉시 Outro를 반환하지 않고,
    // 마지막 대화 완료(onComplete) 시에 별도 화면으로 push 처리합니다.

    // 현재 단계에 따라 화면 결정
    if (coordinator.isInConversation) {
      return ConversationOverlay(
        stage: coordinator.current.stage,
        isFinalConversation: coordinator.current.stage == 7,
        onComplete: () async {
          context.read<HintPopupViewModel>().reset();
          if (coordinator.current.stage == 7) {
            // 마지막 대화(stage 7) 후 Outro 데이터 로드 → push
            final String jsonString = await rootBundle.loadString('assets/data/elem_low/elem_low_outro.json');
            final Map<String, dynamic> data = json.decode(jsonString);
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OutroView(
                  grade: grade,
                  title: grade.appBarTitle,
                  lottieAssetPath: 'assets/animations/furiClear.json',
                  backgroundAssetPath: data['backImage'] ?? 'assets/images/common/bsbackground.png',
                  speakerName: data['speaker'] ?? '푸리',
                  talkText: data['talk'] ?? '',
                  voiceAssetPath: data['voice'] as String?,
                  certificateAssetPath: data['certificate'] ?? 'assets/images/common/certificateElemLow.png',
                ),
              ),
            );
          } else {
            // convN -> missionN 이동
            coordinator.toQuestion(coordinator.current.stage);
          }
        },
        onCloseByBack: () {
          coordinator.handleBack();
        },
      );
    }

    return MissionBackgroundView(
      grade: grade,
      title: grade.appBarTitle,
      missionBuilder: (_) => const ElementaryLowMissionListView(),
      isqr: vm.isqr,
      onBack: () {
        if (!coordinator.handleBack()) {
          Navigator.of(context).pop();
        }
      },
      onHome: () {
        vm.reset();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      hintDialogueBuilder: (dialogContext) {
        final mission = vm.currentMission;
        if (mission == null) return const SizedBox.shrink();
        final hintVM = context.read<HintPopupViewModel>();
        final hints = mission.hints;
        if (hints.isEmpty) return const SizedBox.shrink();

        hintVM.setHints(hints, missionId: mission.id);

        final content = hintVM.consumeNext();
        if (content == null) return const SizedBox.shrink();

        final model = hintVM.buildModel(
          grade: grade,
          content: content,
        );

        return HintPopup(
          model: model,
          onConfirm: () => Navigator.of(dialogContext).pop(),
        );
      },
      onSubmitAnswer: (c) async {
        return await vm.submitAnswer();
      },
      onQRScanned: (scannedValue) async {
        final mission = vm.currentMission;
        if (mission == null) return false;
        return mission.validateQRAnswer(scannedValue);
      },
      onCorrect: () async {
        final int currentStage = coordinator.current.stage;
        
        if (currentStage == 6) {
          vm.setFinalConversationByCoordinator(true);
          coordinator.toConversation(7);
        } else {
          final int nextConversationStage = currentStage + 1;
          coordinator.toConversation(nextConversationStage);
        }
      },
    );
  }
}