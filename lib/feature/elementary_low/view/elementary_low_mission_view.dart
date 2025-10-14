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
          // Coordinator에 VM 참조 설정 (한 번만)
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
    // 최종 대화가 표시되어야 하는 경우 (가장 우선순위)
    if (vm.showFinalConversation) {
      return ConversationOverlay(
        stage: 7, // stage 7 (id: 27)에서 애니메이션 표시
        isFinalConversation: true, // 최종 완료 화면임을 표시
        onComplete: () {
          vm.completeFinalConversation();
          // 최종 대화 완료 후 메인 화면으로 돌아가거나 다른 처리
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
          // 대화 종료 후 문제 이동
          context.read<HintPopupViewModel>().reset();
          
          // 첫 번째 대화 완료 후 첫 번째 문제로 이동
          if (coordinator.current.stage == 1) {
            // 첫 번째 대화 완료 → 첫 번째 문제
            coordinator.toQuestion(1);
          } else {
            // 다른 대화 완료 → 다음 문제 또는 최종 대화
            // conversation(2) 완료 → question(2), conversation(3) 완료 → question(3)
            // conversation(6) 완료 → 최종 대화 (conversation 7)
            if (coordinator.current.stage == 6) {
              // 마지막 대화 완료 → Question6으로 이동
              coordinator.toQuestion(6);
            } else {
              coordinator.toQuestion(coordinator.current.stage);
            }
          }
        },
        onCloseByBack: () {
          // 대화에서 뒤로가기할 때는 VM의 문제 인덱스를 건드리지 않음
          // 코디네이터에서만 히스토리를 관리
          coordinator.handleBack();
        },
      );
    }

    // 기본: 질문 화면 (intro 또는 question 단계)
    return MissionBackgroundView(
      grade: grade,
      title: grade.appBarTitle,
      missionBuilder: (_) => const ElementaryLowMissionListView(),
      isqr: vm.isqr,
      onBack: () {
        // Coordinator의 handleBack을 호출하여 플로우 관리
        if (!coordinator.handleBack()) {
          // Coordinator가 처리하지 못한 경우에만 Navigator pop
          Navigator.of(context).pop();
        }
      },
      onHome: () {
        // 초등 저학년 ViewModel 상태 해제
        vm.reset();
        // 홈으로 이동
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      hintDialogueBuilder: (dialogContext) {
        final mission = vm.currentMission;
        if (mission == null) return const SizedBox.shrink();

        // Use the outer context (under MultiProvider) to access Provider
        final hintVM = context.read<HintPopupViewModel>();
        final hints = mission.hints;
        if (hints.isEmpty) return const SizedBox.shrink();

        // 힌트가 설정되지 않았거나 다른 문제의 힌트인 경우에만 새로 설정
        hintVM.setHints(hints, missionId: mission.id);

        // 다음 힌트 가져오기 (순환)
        final content = hintVM.consumeNext();
        if (content == null) return const SizedBox.shrink();

        final model = hintVM.buildModel(
          grade: grade,
          content: content,
        );

        // MissionBackgroundView에서 showDialog를 호출하므로 여기서는 위젯만 반환
        return HintPopup(
          model: model,
          onConfirm: () => Navigator.of(dialogContext).pop(),
        );
      },
      onSubmitAnswer: (c) async {
        return await vm.submitAnswer();
      },
      onQRScanned: (scannedValue) async {
        // QR 스캔 결과 검증
        final mission = vm.currentMission;
        if (mission == null) return false;
        return mission.validateQRAnswer(scannedValue);
      },
      onCorrect: () async {
        // 정답 후 대화 표시 → stage 기반으로 대화 찾기
        // 문제1 정답 → conversation(2), 문제2 정답 → conversation(3) 등
        // 문제6 정답 → conversation(7) 최종 대화
        final int currentStage = coordinator.current.stage;
        
        if (currentStage == 6) {
          // Q6 정답 → Conv7(최종)
          vm.setFinalConversationByCoordinator(true);
          coordinator.toConversation(7);
        } else {
          final int nextConversationStage = currentStage + 1; // 다음 대화 stage
          coordinator.toConversation(nextConversationStage);
        }
      },
    );
  }
}