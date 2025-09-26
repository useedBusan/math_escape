import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';
import 'elementary_low_mission_list_view.dart';
import 'conversation_overlay.dart';
import '../coordinator/elementary_low_mission_coordinator.dart';
import '../coordinator/flow_step.dart';

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
          
          return WillPopScope(
            onWillPop: () async {
              return !coordinator.handleBack();
            },
            child: _buildCurrentStep(ctx, vm, coordinator, grade),
          );
        },
      ),
    );
  }
  
  Widget _buildCurrentStep(BuildContext context, ElementaryLowMissionViewModel vm, ElementaryLowMissionCoordinator coordinator, StudentGrade grade) {
    print('DEBUG: Mission View - showFinalConversation: ${vm.showFinalConversation}, coordinator.current: ${coordinator.current}');
    
    // 최종 대화가 표시되어야 하는 경우 (가장 우선순위)
    if (vm.showFinalConversation) {
      print('DEBUG: Mission View - Showing final conversation');
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
          print('DEBUG: Elementary Low - Conversation completed, stage=${coordinator.current.stage}');
          // 대화 종료 후 문제 이동
          context.read<HintPopupViewModel>().reset();
          
          // 첫 번째 대화 완료 후 첫 번째 문제로 이동
          if (coordinator.current.stage == 1) {
            // 첫 번째 대화 완료 → 첫 번째 문제
            print('DEBUG: Elementary Low - First conversation completed, moving to question(1)');
            coordinator.toQuestion(1);
          } else {
            // 다른 대화 완료 → 다음 문제 또는 최종 대화
            // conversation(2) 완료 → question(2), conversation(3) 완료 → question(3)
            // conversation(6) 완료 → 최종 대화 (conversation 7)
            if (coordinator.current.stage == 6) {
              // 마지막 대화 완료 → Question6으로 이동
              print('DEBUG: Elementary Low - Last conversation completed, moving to Question(6)');
              coordinator.toQuestion(6);
            } else {
              print('DEBUG: Elementary Low - Conversation completed, moving to next question');
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
      title: '미션! 수사모의 수학 보물을 찾아서',
      missionBuilder: (_) => const ElementaryLowMissionListView(),
      isqr: vm.isqr,
      hintDialogueBuilder: (_) {
        final mission = vm.currentMission;
        if (mission == null) return const SizedBox.shrink();

        final hintVM = context.read<HintPopupViewModel>();
        final hints = mission.hints;

        if (hints.isEmpty) return const SizedBox.shrink();

        // 매번 현재 문제의 힌트로 설정 (문제가 바뀔 때마다 새로 설정)
        hintVM.setHints(hints);

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
        // 문제1 정답 → conversation(2), 문제2 정답 → conversation(3) 등
        // 문제6 정답 → conversation(7) 최종 대화
        final int currentStage = coordinator.current.stage;
        
        if (currentStage == 6) {
          // Q6 정답 → Conv7(최종)
          print('DEBUG: Elementary Low - Answer correct at last question, moving to final conversation');
          vm.setFinalConversationByCoordinator(true);
          coordinator.toConversation(7);
        } else {
          final int nextConversationStage = currentStage + 1; // 다음 대화 stage
          print('DEBUG: Elementary Low - Answer correct! currentStage=$currentStage, nextConversationStage=$nextConversationStage, coordinator.currentQuestionIndex=${coordinator.currentQuestionIndex}, coordinator.current=${coordinator.current}');
          coordinator.toConversation(nextConversationStage);
        }
      },
    );
  }
}
