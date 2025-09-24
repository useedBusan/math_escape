//고등학생 미션 화면 구현

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/view/answer_popup.dart';
import '../../../core/utils/view/qr_scan_screen.dart';
import '../../../Feature/high/view/high_answer.dart';
import '../view_model/high_mission_view_model.dart';
import 'widgets/hourglass_timer_bar.dart';
import 'high_hint_popup.dart';
import '../../../core/services/service_locator.dart';

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
    return ChangeNotifierProvider(
      create: (_) =>
          HighMissionViewModel()
            ..startGame(questionList, initialIndex: currentIndex),
      child: _HighMissionContent(
        currentIndex: currentIndex,
        gameStartTime: gameStartTime,
      ),
    );
  }
}

class _HighMissionContent extends StatefulWidget {
  final int currentIndex;
  final DateTime gameStartTime;

  const _HighMissionContent({
    required this.currentIndex,
    required this.gameStartTime,
  });

  @override
  State<_HighMissionContent> createState() => _HighMissionContentState();
}

class _HighMissionContentState extends State<_HighMissionContent> {
  final TextEditingController _controller = TextEditingController();

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

    if (q.title == '역설, 혹은 모호함_1') {
      vm.goToQuestionById(2);
    } else if (q.title == '역설, 혹은 모호함_3') {
      vm.goToQuestionById(5);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return HighHintPopup(
            hintTitle: '힌트',
            hintContent: q.hint,
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

  void _submitAnswer(HighMissionViewModel vm) {
    final q = vm.currentQuestion;
    final input = _controller.text.trim().toLowerCase();
    final answers = q.answer.map((a) => a.trim().toLowerCase()).toList();
    final isCorrect = answers.contains(input);

    showAnswerPopup(context, isCorrect: isCorrect).then((_) async {
      if (isCorrect) {
        final answerData = await loadAnswerById(q.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HighAnswer(
              answer: answerData,
              gameStartTime: widget.gameStartTime,
              questionList: vm.questionList,
              currentIndex: vm.currentIndex,
            ),
          ),
        );
      }
    });
  }

  void _handleQRScanResult(HighMissionViewModel vm, String qrResult) {
    final q = vm.currentQuestion;

    // QR 스캔 결과가 정답인지 확인 (서비스에서 가져오기)
    final correctQRAnswer = serviceLocator.qrAnswerService
        .getCorrectAnswerByTitle(q.title);
    final isCorrect = correctQRAnswer != null && qrResult == correctQRAnswer;

    // 디버그 정보 출력
    print('QR 스캔 결과: $qrResult');
    print('정답: $correctQRAnswer');
    print('정답 여부: $isCorrect');

    showAnswerPopup(context, isCorrect: isCorrect).then((_) async {
      if (isCorrect) {
        final answerData = await loadAnswerById(q.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HighAnswer(
              answer: answerData,
              gameStartTime: widget.gameStartTime,
              questionList: vm.questionList,
              currentIndex: vm.currentIndex,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HighMissionViewModel>(
      builder: (context, vm, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final q = vm.currentQuestion;
        final Color mainColor = const Color(0xFF3F55A7);

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF3F55A7)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              '역설, 혹은 모호함',
              style: TextStyle(
                color: const Color(0xFF3F55A7),
                fontSize: screenWidth * (16 / 360),
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: const Color(0xFFE8F0FE),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  // 설명 텍스트 (퓨리 이미지 + 텍스트)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // 퓨리 이미지 (왼쪽)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/high/highFuri.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 텍스트 (오른쪽)
                        Expanded(
                          child: Text(
                            '인류의 처음 정수의 정수는 한 개인의\n처음 정수를 만들기 위해 가장 기본이 되는 것,\n곧, 정수!',
                            style: TextStyle(
                              fontFamily: "SBAggroM",
                              fontSize: screenWidth * (14 / 360),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A1A1A),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 3단 레이어 카드
                  Center(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        // 첫번째 레이어 (어두운 배경)
                        Container(
                          width: screenWidth - 60,
                          height: screenHeight * 0.5,
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF192243),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF192243),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                        // 두번째 레이어 (파란색 중간)
                        Container(
                          width: screenWidth - 40,
                          height: screenHeight * 0.5,
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3F55A7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF192243),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                        // 세번째 레이어 (흰색 콘텐츠)
                        Container(
                          width: screenWidth - 20,
                          height: screenHeight * 0.5,
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                          margin: const EdgeInsets.only(top: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF192243),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 문제 번호 + 힌트 버튼
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              // 답변 입력 영역 또는 QR 코드 버튼
                              if (q.title == '역설, 혹은 모호함_4') ...[
                                // QR 코드 문제 - 하나의 버튼으로 통일
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.qr_code_scanner),
                                    label: Text(
                                      'QR코드 스캔',
                                      style: TextStyle(
                                        fontSize: screenWidth * (16 / 360),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final status = await Permission.camera
                                          .request();
                                      if (status.isGranted) {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => QRScanScreen(),
                                          ),
                                        );
                                        if (result != null &&
                                            result is String) {
                                          // QR 스캔 결과를 정답으로 처리
                                          _handleQRScanResult(vm, result);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('카메라 권한이 필요합니다.'),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainColor,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                // 일반 문제 - 기존 입력 필드 + 확인 버튼
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
                                              fontSize:
                                                  screenWidth * (14 / 360),
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
                                              fontSize:
                                                  screenWidth * (14 / 360),
                                              fontWeight: FontWeight.bold,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 하단 모래시계 타이머
                  HourglassTimerBar(
                    mainColor: vm.progressColor,
                    think: vm.thinkText,
                    body: vm.bodyTimeText,
                    progress: vm.thinkProgress,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
