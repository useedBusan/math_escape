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
  late AnimationController _scrollAnimationController;
  late Animation<double> _scrollUpAnimation;
  late Animation<double> _scrollUpOpacity;
  bool _showFirstOverlay = false; // 처음엔 false로 변경
  bool _hasShownConversation = false; // 대화를 본 적 있는지 추적

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

    // 스크롤 애니메이션 컨트롤러 추가
    _scrollAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // 위로 올라가는 애니메이션 반복
    _scrollUpAnimation = Tween<double>(begin: 0.0, end: -30.0).animate(
      CurvedAnimation(
        parent: _scrollAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 투명도 애니메이션 (위로 올라가면서 투명해짐)
    _scrollUpOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _scrollAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // 애니메이션 반복 (위로 올라갔다가 다시 원래 위치로)
    _scrollAnimationController.repeat(reverse: true);
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
    _scrollAnimationController.dispose();
    super.dispose();
  }

  void _showCorrectAnswerDialog(
    MiddleMissionCoordinator coordinator,
    MiddleMissionViewModel viewModel,
  ) async {
    try {
      viewModel.completeQuestion();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
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
          // Coordinator와 ViewModel 연결 설정 (한 번만)
          coordinator.setViewModel(viewModel);

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
                // 시스템 뒤로가기: Coordinator의 handleBack 호출
                final handled = coordinator.handleBack();
                if (!handled && context.mounted) {
                  // Coordinator가 더 이상 처리할 수 없으면 HomeAlert 표시
                  final alertResult = await HomeAlert.show(context);
                  if (alertResult == true && context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }
            },
            child: Stack(
              children: [
                _buildCurrentStep(context, coordinator, viewModel),
                // 첫 진입 오버레이
                if (_showFirstOverlay)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFirstOverlay = false;
                        });
                      },
                      child: Container(
                        color: Color(0xBB000000),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 16),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: "Pretendard",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                          height: 1.5,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: '문제나 힌트가 보이지 않는다면,\n화면을 ',
                                          ),
                                          TextSpan(
                                            text: '스크롤해서',
                                            style: TextStyle(
                                              color: Color(0xFF3F55A7),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' 전부 확인할 수 있어요!',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    SizedBox(
                                      height: 80,
                                      child: AnimatedBuilder(
                                        animation: _scrollAnimationController,
                                        builder: (context, child) {
                                          return Opacity(
                                            opacity: _scrollUpOpacity.value,
                                            child: Transform.translate(
                                              offset: Offset(
                                                0,
                                                _scrollUpAnimation.value,
                                              ),
                                              child: Image.asset(
                                                "assets/images/common/scrollUp.png",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '화면을 터치하여 진행',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Pretendard",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
    if (!viewModel.isInConversation &&
        !_hasShownConversation &&
        !_showFirstOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showFirstOverlay = true;
            _hasShownConversation = true;
          });
        }
      });
    }

    // 현재 상태에 따라 화면 결정
    if (viewModel.isInConversation) {
      return ConversationOverlay(
        stage: viewModel.currentIndex + 1,
        isFinalConversation: false,
        onComplete: () {
          viewModel.goToQuestion(viewModel.currentIndex);
        },
        onCloseByBack: () {
          coordinator.handleBack();
        },
      );
    }

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
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF3F55A7),
            size: 28,
          ),
          onPressed: () {
            coordinator.handleBack();
          },
        ),
        title: Text(
          StudentGrade.middle.appBarTitle,
          style: TextStyle(
            color: const Color(0xFF3F55A7),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Color(0xFF3F55A7), size: 28),
            onPressed: () {
              HomeAlert.showAndNavigate(context);
            },
          ),
        ],
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
                            children: mission.question.toStyledSpans(
                              fontSize: 18,
                            ),
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
                                  fontSize: 17,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // 이미지 영역 (이미지가 있을때만) - 가운데 정렬 및 유동적 높이
                        if (mission.questionImage.isNotEmpty)
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
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
                            height: 52,
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
                                  height: 52,
                                  width: 60,
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
                                  mission.hint1,
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
                  // 하단 여백 추가
                  const SizedBox(height: 100),
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
