import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/core/extensions/string_extension.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/feature/high/model/high_mission_answer.dart';
import '../../../core/views/answer_popup.dart';
import '../../../core/views/qr_scan_screen.dart';
import '../../../core/views/layered_card.dart';
import '../../../feature/high/view/high_answer.dart';
import '../view_model/high_hint_view_model.dart';
import '../view_model/high_mission_view_model.dart';
import '../view_model/high_answer_view_model.dart';
import '../view_model/base_high_view_model.dart';
import 'base_high_view.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/views/hint_popup.dart';
import '../../../core/views/integer_phase_banner.dart';
import '../../../core/models/hint_model.dart';

class HighHintView extends StatelessWidget {
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final DateTime gameStartTime;

  const HighHintView({
    super.key,
    required this.questionList,
    required this.currentIndex,
    required this.gameStartTime,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: HighHintViewModel.instance,
        ),
        ChangeNotifierProvider(
          create: (_) => BaseHighViewModel(),
        ),
      ],
      child: _HighHintContent(
        currentIndex: currentIndex,
        gameStartTime: gameStartTime,
        questionList: questionList,
      ),
    );
  }
}

class _HighHintContent extends StatefulWidget {
  final int currentIndex;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;

  const _HighHintContent({
    required this.currentIndex,
    required this.gameStartTime,
    required this.questionList,
  });

  @override
  State<_HighHintContent> createState() => _HighHintContentState();
}

class _HighHintContentState extends State<_HighHintContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
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
    // HighHintView에서는 힌트 문제 데이터 로드 및 시작
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HighHintViewModel.instance.loadHintQuestions();
      // 현재 문제의 stage에 맞는 힌트 문제로 이동
      final currentQuestion = widget.questionList[widget.currentIndex];
      print('DEBUG: HighHintView initState - currentIndex: ${widget.currentIndex}');
      print('DEBUG: HighHintView initState - currentQuestion.id: ${currentQuestion.id}, stage: ${currentQuestion.stage}');
      print('DEBUG: HighHintView initState - currentQuestion.title: ${currentQuestion.title}');
      HighHintViewModel.instance.goToHintByStage(currentQuestion.stage);
      HighHintViewModel.instance.startHintGame();
    });
  }

  @override
  void dispose() {
    _hintColorController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<MissionAnswer> loadHintAnswerByStage(int stage) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_hint_answer.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => MissionAnswer.fromJson(e))
        .firstWhere((a) => a.stage == stage);
  }

  Future<List<MissionQuestion>> loadQuestionList() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_question.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
  }

  void _showHintDialog(HighHintViewModel vm) {
    final q = vm.currentHintQuestion;
    if (q == null) return;

    // HighHintView에서는 항상 공용 HintPopup 표시
    final hintModel = HintModel(
      hintIcon: 'assets/images/middle/middleHint.png',
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

  void _submitAnswer(HighHintViewModel vm) {
    final q = vm.currentHintQuestion;
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
          final answerData = await loadHintAnswerByStage(q.stage);
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'HighAnswer'),
              builder: (_) => HighAnswer(
                answer: answerData,
                gameStartTime: widget.gameStartTime,
                questionList: widget.questionList,
                currentIndex: widget.currentIndex,
                isFromHint: true,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HighHintViewModel, BaseHighViewModel>(
      builder: (context, vm, baseVm, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              final alertResult = await HomeAlert.show(context);
              if (alertResult == true && context.mounted) {
                // 모든 상태 해제
                HighMissionViewModel.instance.disposeAll();
                HighHintViewModel.instance.disposeAll();
                HighAnswerViewModel.instance.disposeAll();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
          },
          child: BaseHighView(
            title: '역설, 혹은 모호함',
            background: Container(color: CustomGray.lightGray),
            onBack: () {
              // 한 단계만 뒤로가기
              Navigator.of(context).pop();
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
            paneBuilder: (context, pane) => _buildHintContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildHintContent(HighHintViewModel vm) {
    final screenHeight = MediaQuery.of(context).size.height;
    final q = vm.currentHintQuestion;
    final Color mainColor = const Color(0xFF3F55A7);
    
    // 데이터가 로드되지 않은 경우 로딩 표시
    if (q == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 1.5, // 충분한 고정 높이
        child: Column(
          children: [
            IntegerPhaseBanner(
              questionNumber: widget.currentIndex + 1,
              furiImagePath: "assets/images/high/highFuri.png",
              fontSize: 14,
            ),
        const SizedBox(height: 14),
        // 카드 색상은 기존 힌트뷰 스타일 유지
        LayeredCard(
          firstLayerColor: CustomBlue.s300,
          secondLayerColor: CustomBlue.s500,
          thirdLayerColor: const Color(0xFFDEE5FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 문제 번호 + 힌트 버튼
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
                            onPressed: () => _showHintDialog(vm),
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
                                fontSize:
                                    12,
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
                    color: Colors.black,
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
                    border: Border.all(color: const Color(0xffdcdcdc)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          controller: _controller,
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
                      SizedBox(
                        width: 60,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => _submitAnswer(vm),
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
                            '확인',
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
                                final answerData = await loadHintAnswerByStage(q.stage);
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: const RouteSettings(name: 'HighAnswer'),
                                    builder: (_) => HighAnswer(
                                      answer: answerData,
                                      gameStartTime: widget.gameStartTime,
                                      questionList: widget.questionList,
                                      currentIndex: widget.currentIndex,
                                      isFromHint: true,
                                    ),
                                  ),
                                );
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
