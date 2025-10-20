import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/hint_popup.dart';
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
    if (vm.showFinalConversation) {
      return ConversationOverlay(
        stage: 7,
        isFinalConversation: true,
        onComplete: () {
          vm.completeFinalConversation();
          Navigator.of(context).pop();
        },
        onCloseByBack: () {
          vm.completeFinalConversation();
          Navigator.of(context).pop();
        },
      );
    }

    // 현재 단계에 따라 화면 결정
    if (coordinator.isInConversation) {
      return ConversationOverlay(
        stage: coordinator.current.stage,
        isFinalConversation: coordinator.current.stage == 7,
        onComplete: () {
          context.read<HintPopupViewModel>().reset();

          if (coordinator.current.stage == 1) {
            coordinator.toQuestion(1);
          } else {
            if (coordinator.current.stage == 6) {
              coordinator.toQuestion(6);
            } else {
              coordinator.toQuestion(coordinator.current.stage);
            }
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