import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../core/views/answer_popup.dart';
import '../../../core/views/qr_scan_screen.dart';
import '../../../core/views/layered_card.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/views/hint_popup.dart';
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

class _HighMissionContentState extends State<_HighMissionContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HighMissionViewModel.instance.startGame(
        widget.questionList,
        initialIndex: widget.currentIndex,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<MissionAnswer> loadAnswerById(int id) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_answer.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => MissionAnswer.fromJson(e))
        .firstWhere((a) => a.id == id);
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
        if (isCorrect) {
          final answerData = await loadAnswerById(q.id);
          if (!mounted) return; // ✅ context 안전 확인
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
        } else {
          if (!mounted) return;
          Navigator.of(context).pop();
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
                // 모든 상태 해제
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
            paneBuilder: (context, pane) => _buildMissionContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildMissionContent(HighMissionViewModel vm) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final q = vm.currentQuestion;
    final Color mainColor = const Color(0xFF3F55A7);

    // 데이터가 로드되지 않은 경우 로딩 표시
    if (q == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 1.5, // 충분한 고정 높이
        child: Column(
          children: [
            const SizedBox(height: 14),
            // 설명 텍스트 (퓨리 이미지 + 텍스트)
            Row(
              children: [
                // 퓨리 이미지 공간 (왼쪽)
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Image.asset(
                      "assets/images/high/highFuri.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 텍스트 (오른쪽)
                Expanded(
                  child: Text(
                    '인류의 처음 정수의 정수는 한 개인의 처음 정수를 만들기 위해 가장 기본이 되는 것. 곧, 정수!',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: screenWidth * (12 / 360),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
            // 최적화된 배경 이미지 카드
            LayeredCard(
              height: screenHeight * 0.5,
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
                          fontSize: screenWidth * (18 / 360),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff202020),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.help_outline,
                              color: Color(0xFF3F55A7),
                            ),
                            onPressed: () => _showHintDialog(vm),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 28,
                          ),
                          const SizedBox(height: 4),
                          Transform.translate(
                            offset: const Offset(0, -15),
                            child: Text(
                              '힌트',
                              style: TextStyle(
                                color: const Color(0xFF3F55A7),
                                fontSize: screenWidth * (12 / 360),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 문제 영역
                  Text(
                    q.question,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w400,
                      fontSize: screenWidth * (16 / 360),
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // 답변 입력 영역 (isqr가 false인 경우에만)
                  if (!q.isqr) ...[
                    Container(
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
                                fontSize: screenWidth * (15 / 360),
                              ),
                              controller: _controller,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: '정답을 입력해 주세요.',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * (14 / 360),
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
                                  fontSize: screenWidth * (14 / 360),
                                  fontWeight: FontWeight.bold,
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
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => QRScanScreen()),
                          );

                          if (result != null && result is String) {
                            final isCorrect = q.validateQRAnswer(result);
                            if (!mounted) return; // ✅ context 안전 확인

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AnswerPopup(
                                isCorrect: isCorrect,
                                grade: StudentGrade.high,
                                onNext: () async {
                                  Navigator.pop(context);
                                  if (isCorrect) {
                                    final answerData = await loadAnswerById(
                                      q.id,
                                    );
                                    if (!mounted) return; // ✅ context 안전 확인
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
                                fontSize:
                                    MediaQuery.of(context).size.width *
                                    (16 / 360),
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
