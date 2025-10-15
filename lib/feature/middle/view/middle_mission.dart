import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/answer_popup.dart';
import '../../../core/views/common_intro_view.dart';
import '../../../core/viewmodels/intro_view_model.dart';
import '../../../constants/enum/image_enums.dart';
import '../../../core/views/layered_card.dart';
import '../../../core/views/qr_scan_screen.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/extensions/string_extension.dart';
import '../coordinator/middle_mission_coordinator.dart';
import '../model/middle_mission_model.dart';
import '../view_model/middle_mission_view_model.dart';
import 'conversation_overlay.dart';

// MiddleMissionScreen
class MiddleMissionScreen extends StatefulWidget {
  const MiddleMissionScreen({super.key});

  @override
  State<MiddleMissionScreen> createState() => _MiddleMissionScreenState();
}

class _MiddleMissionScreenState extends State<MiddleMissionScreen>
    with TickerProviderStateMixin {
  late AnimationController _hintColorController;
  late Animation<double> _hintColorAnimation;

  @override
  void initState() {
    super.initState();

    _hintColorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _hintColorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hintColorController, curve: Curves.easeInOut),
    );

    _hintColorController.repeat(reverse: true);
  }

  void _syncWithCoordinator(
    int coordinatorIndex,
    MiddleMissionViewModel viewModel,
  ) {
    if (coordinatorIndex != viewModel.currentIndex) {
      viewModel.setCurrentIndex(coordinatorIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final mission = viewModel.currentMission;
        final imagePath = mission?.questionImage;
        if (imagePath != null && imagePath.isNotEmpty && mounted) {
          precacheImage(AssetImage(imagePath), context);
        }
      });
    }
  }

  void _submitAnswer(
    MiddleMissionCoordinator coordinator,
    MiddleMissionViewModel viewModel,
  ) async {
    final MissionItem? currentMission = viewModel.currentMission;
    if (currentMission == null) return;

    if (currentMission.isqr) {
      // QR 문제일 때는 QR 스캔 화면으로 이동
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QRScanScreen()),
      );

      if (result != null && result is String) {
        // 스캔된 값으로 정답 검증
        final isCorrect = viewModel.validateQRAnswer(result);

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AnswerPopup(
              isCorrect: isCorrect,
              onNext: () {
                Navigator.pop(context);
                if (isCorrect) {
                  _showCorrectAnswerDialog(coordinator, viewModel);
                }
              },
              grade: StudentGrade.middle,
            ),
          );
        }
      }
    } else {
      // 일반 문제일 때는 기존 로직 사용
      final bool correct = await viewModel.submitAnswer();

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AnswerPopup(
            isCorrect: correct,
            onNext: () {
              Navigator.pop(context);
              if (correct) {
                _showCorrectAnswerDialog(coordinator, viewModel);
              }
            },
            grade: StudentGrade.middle,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _hintColorController.dispose();
    super.dispose();
  }

  void _showCorrectAnswerDialog(
    MiddleMissionCoordinator coordinator,
    MiddleMissionViewModel viewModel,
  ) async {
    try {
      final int currentQuestionId = viewModel.currentIndex + 1;
      coordinator.toConversation(currentQuestionId);
    } catch (e) {
      if (viewModel.currentIndex + 1 >= viewModel.totalCount) {
        Navigator.of(context).pop();
      } else {
        viewModel.goToNextQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MiddleMissionCoordinator()),
        ChangeNotifierProvider(create: (_) => MiddleMissionViewModel()),
      ],
      child: Consumer2<MiddleMissionCoordinator, MiddleMissionViewModel>(
        builder: (context, coordinator, viewModel, child) {
          // Coordinator와 동기화 설정 (한 번만)
          coordinator.setQuestionIndexCallback(
            (index) => _syncWithCoordinator(index, viewModel),
          );

          // 데이터 로드 (build 완료 후 실행)
          if (viewModel.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadMissionData();
            });
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                final alertResult = await HomeAlert.show(context);
                if (alertResult == true && context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: _buildCurrentStep(context, coordinator, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    MiddleMissionCoordinator coordinator,
    MiddleMissionViewModel viewModel,
  ) {
    // 현재 단계에 따라 화면 결정
    if (coordinator.isInConversation) {
      return ConversationOverlay(
        stage: coordinator.current.stage,
        isFinalConversation: false,
        onComplete: () {
          // 대화 종료 후 다음 문제 이동 또는 완료 처리
          final int nextStage = coordinator.current.stage + 1;
          if (nextStage <= viewModel.totalCount) {
            coordinator.toQuestion(nextStage);
          } else {
            // 모든 문제 완료 - 메인 화면으로 이동
            Navigator.of(context).pop();
          }
        },
        onCloseByBack: () {
          // 대화에서 뒤로가기할 때는 코디네이터에서만 히스토리를 관리
          coordinator.handleBack();
        },
      );
    }

    // 기본: 질문 화면 (question 단계)
    return _buildQuestionScreen(context, coordinator, viewModel);
  }

  Widget _buildQuestionScreen(
    BuildContext context,
    MiddleMissionCoordinator coordinator,
    MiddleMissionViewModel viewModel,
  ) {
    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.missions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("미션 데이터를 불러오는 데 실패했습니다.")),
      );
    }

    final MissionItem? mission = viewModel.currentMission;
    if (mission == null) {
      return const Scaffold(body: Center(child: Text("현재 미션을 불러올 수 없습니다.")));
    }

    final Color mainColor = const Color(0xFF3F55A7);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F55A7)),
          onPressed: () async {
            final alertResult = await HomeAlert.show(context);
            if (alertResult == true && context.mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          StudentGrade.middle.appBarTitle,
          style: TextStyle(
            color: const Color(0xFF3F55A7),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              mission.backImage.isNotEmpty
                  ? mission.backImage
                  : ImageAssets.background.path,
              fit: BoxFit.cover,
            ),
          ),
          // 위에 덮는 gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.75),
                    Color.fromRGBO(0, 0, 0, 0.50),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // 실제 콘텐츠 (스크롤 가능)
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  Column(
                    children: [
                      Text(
                        '각 문제마다 2개의 힌트가 있어.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "SBAggroM",
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFF2F2F2),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2개의 힌트를 활용해 수학자의 비밀 노트를 찾아내자!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "SBAggroM",
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFFF2F2F2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LayeredCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '문제 ${viewModel.currentIndex + 1} / ${viewModel.totalCount}',
                              style: TextStyle(
                                fontFamily: "SBAggroM",
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff202020),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedBuilder(
                                  animation: _hintColorAnimation,
                                  builder: (context, child) {
                                    final color = Color.lerp(
                                      const Color(0xFF3F55A7),
                                      const Color(0xFFB2BBDC),
                                      _hintColorAnimation.value,
                                    )!;
                                    return IconButton(
                                      icon: Icon(
                                        Icons.help_outline,
                                        color: color,
                                      ),
                                      onPressed: () =>
                                          viewModel.showHintDialog(),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      iconSize: 28,
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                AnimatedBuilder(
                                  animation: _hintColorAnimation,
                                  builder: (context, child) {
                                    final color = Color.lerp(
                                      const Color(0xFF3F55A7),
                                      const Color(0xFFB2BBDC),
                                      _hintColorAnimation.value,
                                    )!;
                                    return Transform.translate(
                                      offset: const Offset(0, -15),
                                      child: Text(
                                        '힌트',
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: mission.questionImage.isEmpty ? 4 : 8),
                        // 문제 영역
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.4,
                              color: Colors.black87,
                            ),
                            children: mission.question.toStyledSpans(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 선택지 영역 (options가 있을 때만)
                        if (mission.options != null &&
                            mission.options!.isNotEmpty) ...[
                          ...mission.options!.map(
                            (option) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        // 이미지 영역 (이미지가 있을때만) - 가운데 정렬 및 유동적 높이
                        if (mission.questionImage.isNotEmpty)
                          SizedBox(
                            height: 200, // 고정 높이로 설정하여 비율 유지
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  mission.questionImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        // QR 문제일 때 QR 스캔 버튼 표시
                        if (mission.isqr) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _submitAnswer(coordinator, viewModel),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code_scanner,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'QR코드 스캔',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          // 일반 문제일 때 텍스트필드 표시
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: const Color(0xffdcdcdc),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    style: TextStyle(fontSize: 15),
                                    controller: viewModel.answerController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      hintText: '정답을 입력해 주세요.',
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: const Color(0xffaaaaaa),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 12.0,
                                          ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _submitAnswer(coordinator, viewModel),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '제출',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 힌트 카드
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      // 힌트 1
                      AnimatedSlide(
                        duration: viewModel.showHint1
                            ? const Duration(milliseconds: 300)
                            : Duration.zero,
                        curve: Curves.easeOut,
                        offset: viewModel.showHint1
                            ? Offset.zero
                            : const Offset(0, 0.1),
                        child: AnimatedOpacity(
                          duration: viewModel.showHint1
                              ? const Duration(milliseconds: 300)
                              : Duration.zero,
                          opacity: viewModel.showHint1 ? 1.0 : 0.0,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * (16 / 360),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEBEB),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: const Color(0xFFEBEBEB),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '단서#1 : 목적지의 비밀',
                                  style: TextStyle(
                                    fontSize:
                                        16,
                                    fontFamily: "SBAggroM",
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF101351),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width *
                                      (8 / 360),
                                ),
                                Text(
                                  mission.hint1,
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                        16,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (viewModel.showHint1 && viewModel.showHint2)
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.width * (12 / 360),
                        ),

                      // 힌트 2
                      AnimatedSlide(
                        duration: viewModel.showHint2
                            ? const Duration(milliseconds: 300)
                            : Duration.zero,
                        curve: Curves.easeOut,
                        offset: viewModel.showHint2
                            ? Offset.zero
                            : const Offset(0, 0.1),
                        child: AnimatedOpacity(
                          duration: viewModel.showHint2
                              ? const Duration(milliseconds: 300)
                              : Duration.zero,
                          opacity: viewModel.showHint2 ? 1.0 : 0.0,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * (16 / 360),
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBEBEB),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: const Color(0xFFEBEBEB),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '단서#2 : 마지막 열쇠',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "SBAggroM",
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF101351),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width *
                                      (8 / 360),
                                ),
                                Text(
                                  mission.hint2,
                                  style: TextStyle(
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 중학교 대화 시퀀스를 관리하는 전용 위젯
class _MiddleConversationView extends StatefulWidget {
  final IntroViewModel viewModel;
  final VoidCallback onComplete;

  const _MiddleConversationView({
    required this.viewModel,
    required this.onComplete,
  });

  @override
  State<_MiddleConversationView> createState() =>
      _MiddleConversationViewState();
}

class _MiddleConversationViewState extends State<_MiddleConversationView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<IntroViewModel>(
        builder: (context, vm, child) {
          final talk = vm.currentTalk;

          return CommonIntroView(
            appBarTitle: '수학자의 비밀 노트를 찾아라!',
            backgroundAssetPath: talk.backImg,
            characterImageAssetPath: talk.speakerImg,
            speakerName: '푸리',
            talkText: talk.talk,
            buttonText: '확인',
            grade: StudentGrade.middle,
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
