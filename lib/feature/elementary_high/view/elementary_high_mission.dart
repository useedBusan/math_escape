import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/hint_popup.dart';
import '../../../core/views/mission_background_view.dart';
import '../../../core/viewmodels/hint_popup_view_model.dart';
import '../view_model/elementary_high_mission_view_model.dart';
import 'elementary_high_mission_list_view.dart';
import 'conversation_overlay.dart';
import '../coordinator/elementary_high_mission_coordinator.dart';
import '../../../core/views/outro_view.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


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
          // Coordinator와 view_model 동기화 설정 (한 번만)
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
          
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                coordinator.handleBack();
              }
            },
            child: _buildCurrentStep(context, vm, coordinator, grade),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, ElementaryHighMissionViewModel vm, ElementaryHighMissionCoordinator coordinator, StudentGrade grade) {
    // 최종 대화가 표시되어야 하는 경우
    // 최종 분기는 대화 onComplete에서 push로 처리

    // 현재 단계에 따라 화면 결정
    if (coordinator.isInConversation) {
      final int lastStage = vm.totalCount; // 총 문제 수 = 마지막 stage
      return ConversationOverlay(
        stage: coordinator.current.stage,
        isFinalConversation: coordinator.current.stage == lastStage,
        onComplete: () async {
          context.read<HintPopupViewModel>().reset();
          if (coordinator.current.stage == lastStage) {
            final String jsonString = await rootBundle.loadString('assets/data/elem_high/elem_high_outro.json');
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
                  certificateAssetPath: data['certificate'] ?? 'assets/images/common/certificateElemHigh.png',
                ),
              ),
            );
          } else {
            vm.nextMission();
            coordinator.toQuestion(coordinator.current.stage + 1);
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
      missionBuilder: (_) => const ElementaryHighMissionListView(),
      isqr: vm.isqr,
      onBack: () {
        // Coordinator의 handleBack을 호출하여 플로우 관리
        if (!coordinator.handleBack()) {
          // Coordinator가 처리하지 못한 경우에만 Navigator pop
          Navigator.of(context).pop();
        }
      },
      onHome: () {
        // 초등 고학년 ViewModel 상태 해제
        vm.reset();
        // 홈으로 이동
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      hintDialogueBuilder: (_) {
        final mission = vm.currentMission;
        if (mission == null) return const SizedBox.shrink();

        final hintVM = context.read<HintPopupViewModel>();
        final hints = mission.hintModel.hints;

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

        return HintPopup(
          model: model,
          onConfirm: () => Navigator.of(context).pop(),
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
        // 문제1 정답 → conversation(1), 문제2 정답 → conversation(2) 등
        // 코디네이터의 현재 question stage를 사용하여 정확한 대화 stage 계산
        final int currentStage = coordinator.current.stage;
        final int lastStage = vm.totalCount;
        if (currentStage == lastStage) {
          // 마지막 문제면 대화로 가지 않고 Outro로 이동
          final String jsonString = await rootBundle.loadString('assets/data/elem_high/elem_high_outro.json');
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
                certificateAssetPath: data['certificate'] ?? 'assets/images/common/certificateElemHigh.png',
              ),
            ),
          );
        } else {
          coordinator.toConversation(currentStage);
        }
      },
    );
  }
}
