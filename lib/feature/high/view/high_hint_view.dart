import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/feature/high/model/high_mission_answer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/view/answer_popup.dart';
import '../../../core/utils/view/qr_scan_screen.dart';
import '../../../feature/high/view/high_answer.dart';
import '../view_model/high_hint_view_model.dart';
import 'base_high_view.dart';
import '../view_model/base_high_view_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/view/home_alert.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../core/utils/model/hint_model.dart';

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

class _HighHintContentState extends State<_HighHintContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // HighHintView에서는 힌트 문제 데이터 로드 및 시작
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HighHintViewModel.instance.loadHintQuestions();
      // 현재 문제의 stage에 맞는 힌트 문제로 이동
      final currentQuestion = widget.questionList[widget.currentIndex];
      print('DEBUG: HighHintView initState - currentIndex: ${widget.currentIndex}');
      print('DEBUG: HighHintView initState - currentQuestion.id: ${currentQuestion.id}, stage: ${currentQuestion.stage}');
      HighHintViewModel.instance.goToHintByStage(currentQuestion.stage);
      HighHintViewModel.instance.startHintGame();
    });
  }

  @override
  void dispose() {
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
      }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AnswerPopup(
            isCorrect: isCorrect,
            grade: StudentGrade.elementaryHigh,
            onNext: () {},
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _submitAnswer(HighHintViewModel vm) {
    final q = vm.currentHintQuestion;
    if (q == null) return;
    
    final input = _controller.text.trim().toLowerCase();
    final answers = q.answer.map((a) => a.trim().toLowerCase()).toList();
    final isCorrect = answers.contains(input);

    showAnswerPopup(context, isCorrect: isCorrect).then((_) async {
      if (isCorrect) {
        final answerData = await loadHintAnswerByStage(q.stage);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HighAnswer(
              answer: answerData,
              gameStartTime: widget.gameStartTime,
              questionList: widget.questionList, // 원래 문제 리스트 사용
              currentIndex: widget.currentIndex, // 원래 인덱스 사용
              isFromHint: true, // 힌트에서 온 것임을 표시
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HighHintViewModel, BaseHighViewModel>(
      builder: (context, vm, baseVm, child) {
        return WillPopScope(
          onWillPop: () async {
            final result = await HomeAlert.show(context);
            if (result == true) {
              // 타이머 초기화
              HighHintViewModel.instance.endHintGame();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            return false; // 기본 뒤로가기 동작 방지
          },
          child: BaseHighView(
            title: '역설, 혹은 모호함',
            background: Container(color: CustomGray.lightGray),
            paneBuilder: (context, pane) => _buildHintContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildHintContent(HighHintViewModel vm) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                  fontSize: screenWidth * (14 / 360),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1A1A1A),
                  // height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: 10),
        // 최적화된 배경 이미지 카드
        Center(
          child: Container(
            width: screenWidth - 20,
            height: screenHeight * 0.5,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/high/highHintBackground.png'),
                fit: BoxFit.contain,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 44),
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
                const Expanded(child: SizedBox()),
                // 답변 입력 영역 (isqr가 false인 경우에만)
                if (!q.isqr) ...[
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
                          MaterialPageRoute(
                            builder: (_) => QRScanScreen(),
                          ),
                        );
                        if (result != null && result is String) {
                          final isCorrect = q.validateQRAnswer(result);
                          
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => AnswerPopup(
                              isCorrect: isCorrect,
                              grade: StudentGrade.high,
                              onNext: () async {
                                Navigator.pop(context);
                                if (isCorrect) {
                                  // 정답인 경우 다음 단계로 진행
                                  final answerData = await loadHintAnswerByStage(q.stage);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
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
                              fontSize: MediaQuery.of(context).size.width * (16 / 360),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }
}
