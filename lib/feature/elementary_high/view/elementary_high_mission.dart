import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/view/mission_background_view.dart';
import '../../../core/utils/view_model/hint_popup_view_model.dart';
import '../view_model/elementary_high_mission_view_model.dart';
import 'elementary_high_mission_list_view.dart';
import 'conversation_overlay.dart';
import '../coordinator/elementary_high_mission_coordinator.dart';
import '../coordinator/flow_step.dart';


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
        ChangeNotifierProvider(create: (_) => ElementaryHighMissionCoordinator()),
      ],
      child: Consumer2<ElementaryHighMissionViewModel, ElementaryHighMissionCoordinator>(
        builder: (context, vm, coordinator, child) {
          // Coordinator와 ViewModel 동기화 설정 (한 번만)
          if (!vm.hasIndexCallback) {
            vm.setIndexChangedCallback((index) {
              // Coordinator에서 VM으로 인덱스 변경 알림
              vm.syncWithCoordinator(index);
            });
            coordinator.setQuestionIndexCallback((index) {
              // VM에서 Coordinator로 인덱스 변경 알림
              vm.syncWithCoordinator(index);
            });
          }
          
          // VM의 currentIndex를 코디네이터와 동기화
          vm.syncWithCoordinator(coordinator.currentQuestionIndex);
          
          return WillPopScope(
            onWillPop: () async {
              return !coordinator.handleBack();
            },
            child: _buildCurrentStep(context, vm, coordinator, grade),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, ElementaryHighMissionViewModel vm, ElementaryHighMissionCoordinator coordinator, StudentGrade grade) {
    // 최종 대화가 표시되어야 하는 경우
    if (vm.showFinalConversation) {
      return ConversationOverlay(
        stage: 10, // stage 10 (id: 11)에서 애니메이션 표시
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
        isFinalConversation: coordinator.current.stage == 10,
        onComplete: () {
          print('DEBUG: Conversation completed');
          // 대화 종료 후 다음 문제 이동
          context.read<HintPopupViewModel>().reset();
          
          // VM의 nextMission을 호출하여 다음 문제로 이동
          vm.nextMission();
          
          // Coordinator도 다음 문제 stage로 이동
          coordinator.toQuestion(coordinator.current.stage + 1);
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
        // 문제1 정답 → conversation(1), 문제2 정답 → conversation(2) 등
        // 코디네이터의 현재 question stage를 사용하여 정확한 대화 stage 계산
        final int currentStage = coordinator.current.stage;
        print('DEBUG: onCorrect called, currentStage=$currentStage, coordinator.currentQuestionIndex=${coordinator.currentQuestionIndex}, coordinator.current=${coordinator.current}');
        coordinator.toConversation(currentStage);
      },
    );
  }
}
