import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/core/extensions/string_extension.dart';
import 'package:provider/provider.dart';
import '../../../feature/high/model/high_mission_answer.dart';
import '../../../constants/enum/grade_enums.dart';
import '../model/high_mission_question.dart';
import 'dart:async';
import 'high_answer.dart';
import '../view_model/high_mission_view_model.dart';
import '../view_model/high_hint_view_model.dart';
import '../view_model/high_answer_view_model.dart';
import '../view_model/base_high_view_model.dart';
import 'high_hint_view.dart';
import 'base_high_view.dart';
import 'high_clear_view.dart';
import '../../../core/views/answer_popup.dart';
import '../../../core/views/qr_scan_screen.dart';
import '../../../core/views/layered_card.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/views/hint_popup.dart';
import '../../../core/views/integer_phase_banner.dart';
import '../../../core/models/hint_model.dart';
import '../../../app/theme/app_colors.dart';

class HighMission extends StatelessWidget {
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final DateTime gameStartTime;

  const HighMission({
    super.key,
    required this.questionList,
    required this.currentIndex,
    required this.gameStartTime,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: HighMissionViewModel.instance),
        ChangeNotifierProvider(create: (_) => BaseHighViewModel()),
      ],
      child: _HighMissionContent(
        currentIndex: currentIndex,
        gameStartTime: gameStartTime,
        questionList: questionList,
      ),
    );
  }
}

class _HighMissionContent extends StatefulWidget {
  final int currentIndex;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;

  const _HighMissionContent({
    required this.currentIndex,
    required this.gameStartTime,
    required this.questionList,
  });

  @override
  State<_HighMissionContent> createState() => _HighMissionContentState();
}

class _HighMissionContentState extends State<_HighMissionContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late FocusNode _answerFocusNode;
  late AnimationController _hintColorController;
  late Animation<double> _hintColorAnimation;

  @override
  void initState() {
    super.initState();
    _answerFocusNode = FocusNode();
    _answerFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    _hintColorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _hintColorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hintColorController, curve: Curves.easeInOut),
    );

    // 반복 애니메이션 시작
    _hintColorController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      HighMissionViewModel.instance.startGame(
        widget.questionList,
        initialIndex: widget.currentIndex,
      );
    });
  }

  @override
  void dispose() {
    _hintColorController.dispose();
    _controller.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  Future<MissionAnswer> loadAnswerById(int id) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_answer.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    try {
      return jsonData
          .map((e) => MissionAnswer.fromJson(e))
          .firstWhere((a) => a.id == id);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MissionQuestion>> loadQuestionList() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_question.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
  }

  void _showHintDialog(HighMissionViewModel vm) {
    final q = vm.currentQuestion;
    if (q == null) return;

    if (q.isHint) {
      // isHint = true인 경우 HighHintView로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'HighHint'),
          builder: (_) => HighHintView(
            questionList: vm.questionList,
            currentIndex: vm.currentIndex,
            gameStartTime: widget.gameStartTime,
          ),
        ),
      );
    } else {
      // isHint = false인 경우 공용 HintPopup 표시
      final hintModel = HintModel(
        hintIcon: 'assets/images/middle/middleHint.webp',
        upString: '힌트',
        downString: q.hint,
        hintImg: null,
        hintVideo: null,
        mainColor: CustomBlue.s500,
      );

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return HintPopup(
            model: hintModel,
            onConfirm: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  Future<void> showAnswerPopup(
    BuildContext context, {
    required bool isCorrect,
    required VoidCallback onNext,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnswerPopup(
        isCorrect: isCorrect,
        grade: StudentGrade.high,
        onNext: onNext,
      ),
    );
  }

  void _submitAnswer(HighMissionViewModel vm) {
    final q = vm.currentQuestion;
    if (q == null) return;

    final input = _controller.text.trim().toLowerCase();
    final answers = q.answer.map((a) => a.trim().toLowerCase()).toList();
    final isCorrect = answers.contains(input);

    showAnswerPopup(
      context,
      isCorrect: isCorrect,
      onNext: () async {
        // 정답 팝업 닫기
        Navigator.of(context).pop();
        if (!mounted) return;

        if (isCorrect) {
          // 마지막 문제인지 확인 (currentIndex가 0-based이므로 마지막 문제는 questionList.length - 1)
          if (vm.currentIndex == vm.questionList.length - 1) {
            // 마지막 문제인 경우 바로 HighClearView로 이동
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HighClearView(gameStartTime: widget.gameStartTime),
              ),
            );
          } else {
            // 일반 문제인 경우 HighAnswer로 이동
            final answerData = await loadAnswerById(q.id);
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'HighAnswer'),
                builder: (_) => HighAnswer(
                  answer: answerData,
                  gameStartTime: widget.gameStartTime,
                  questionList: vm.questionList,
                  currentIndex: vm.currentIndex,
                  isFromHint: false,
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HighMissionViewModel, BaseHighViewModel>(
      builder: (context, vm, baseVm, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              final alertResult = await HomeAlert.show(context);
              if (alertResult == true && context.mounted) {
                HighMissionViewModel.instance.disposeAll();
                HighHintViewModel.instance.disposeAll();
                HighAnswerViewModel.instance.disposeAll();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
          },
          child: BaseHighView(
            title: StudentGrade.high.appBarTitle,
            background: Container(color: const Color(0xFFE8F0FE)),
            onBack: () async {
              // 첫 번째 미션이 아니면 이전 미션으로
              if (vm.currentIndex > 0) {
                vm.goToQuestion(vm.currentIndex - 1);
              } else {
                // 첫 번째 미션에서 뒤로가기하면 홈으로
                final alertResult = await HomeAlert.show(context);
                if (alertResult == true && context.mounted) {
                  HighMissionViewModel.instance.disposeAll();
                  HighHintViewModel.instance.disposeAll();
                  HighAnswerViewModel.instance.disposeAll();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              }
            },
            onHome: () async {
              // 홈으로: 확인 후 상태 해제 및 루트로 이동
              final alertResult = await HomeAlert.show(context);
              if (alertResult == true && context.mounted) {
                HighMissionViewModel.instance.disposeAll();
                HighHintViewModel.instance.disposeAll();
                HighAnswerViewModel.instance.disposeAll();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            paneBuilder: (context, pane) => _buildMissionContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildMissionContent(HighMissionViewModel vm) {
    final screenHeight = MediaQuery.of(context).size.height;
    final q = vm.currentQuestion;
    final Color mainColor = const Color(0xFF3F55A7);

    // 데이터가 로드되지 않은 경우 로딩 표시
    if (q == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 1.5,
        child: Column(
          children: [
            IntegerPhaseBanner(
              questionNumber: vm.currentIndex + 1,
              furiImagePath: "assets/images/high/highFuri.webp",
              fontSize: 14,
            ),
            const SizedBox(height: 14),
            LayeredCard(
              height: screenHeight * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        q.title,
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
                          q.isHint
                              ? AnimatedBuilder(
                            animation: _hintColorAnimation,
                            builder: (context, child) {
                              // 투명도를 1.0에서 0.1로 변화
                              final opacity = 1.0 - (_hintColorAnimation.value * 0.9);
                              return Opacity(
                                opacity: opacity,
                                child: IconButton(
                                  icon: Image.asset(
                                    "assets/images/high/hintHintIcon.webp",
                                    height: 40,
                                  ),
                                  onPressed: () => _showHintDialog(vm),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              );
                            },
                          )
                              : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _hintColorAnimation,
                                builder: (context, child) {
                                  // 투명도를 1.0에서 0.1로 변화
                                  final opacity = 1.0 - (_hintColorAnimation.value * 0.9);
                                  return Opacity(
                                    opacity: opacity,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.help_outline,
                                        color: const Color(0xFF3F55A7),
                                      ),
                                      onPressed: () => _showHintDialog(vm),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      iconSize: 28,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              AnimatedBuilder(
                                animation: _hintColorAnimation,
                                builder: (context, child) {
                                  // 투명도를 1.0에서 0.1로 변화
                                  final opacity = 1.0 - (_hintColorAnimation.value * 0.9);
                                  return Transform.translate(
                                    offset: const Offset(0, -15),
                                    child: Opacity(
                                      opacity: opacity,
                                      child: Text(
                                        '힌트',
                                        style: TextStyle(
                                          color: const Color(0xFF3F55A7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 문제 영역
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                      children: q.question.toStyledSpans(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 답변 입력 영역 (isqr가 false인 경우에만)
                  if (!q.isqr) ...[
                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: _answerFocusNode.hasFocus
                              ? CustomBlue.s500
                              : const Color(0xffdcdcdc),
                          width: _answerFocusNode.hasFocus ? 2.0 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              style: TextStyle(fontSize: 15),
                              controller: _controller,
                              focusNode: _answerFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: '정답을 입력해 주세요.',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xffaaaaaa),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 12.0,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _submitAnswer(vm),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                _answerFocusNode.hasFocus ? 6.0 : 7.0,
                              ),
                              bottomRight: Radius.circular(
                                _answerFocusNode.hasFocus ? 6.0 : 7.0,
                              ),
                            ),
                            child: Container(
                              height: 52,
                              width: _answerFocusNode.hasFocus ? 59.0 : 60.0,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    _answerFocusNode.hasFocus ? 6.0 : 7.0,
                                  ),
                                  bottomRight: Radius.circular(
                                    _answerFocusNode.hasFocus ? 6.0 : 7.0,
                                  ),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // QR 코드 버튼 (isqr가 true인 문제에서만)
                  if (q.isqr) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => QRScanScreen()),
                          );

                          if (result != null && result is String) {
                            final isCorrect = q.validateQRAnswer(result);
                            if (!mounted) return;

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AnswerPopup(
                                isCorrect: isCorrect,
                                grade: StudentGrade.high,
                                onNext: () async {
                                  Navigator.pop(context);
                                  if (isCorrect) {
                                    // 마지막 문제인지 확인 (currentIndex가 0-based이므로 마지막 문제는 questionList.length - 1)
                                    if (vm.currentIndex ==
                                        vm.questionList.length - 1) {
                                      // 마지막 문제인 경우 바로 HighClearView로 이동
                                      if (!mounted) return;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => HighClearView(
                                            gameStartTime: widget.gameStartTime,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // 일반 문제인 경우 HighAnswer로 이동
                                      final answerData = await loadAnswerById(
                                        q.id,
                                      );
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings: const RouteSettings(
                                            name: 'HighAnswer',
                                          ),
                                          builder: (_) => HighAnswer(
                                            answer: answerData,
                                            gameStartTime: widget.gameStartTime,
                                            questionList: vm.questionList,
                                            currentIndex: vm.currentIndex,
                                            isFromHint: false,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                          }
                        },
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
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
