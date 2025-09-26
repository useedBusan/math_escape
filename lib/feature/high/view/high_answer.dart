import 'package:flutter/material.dart';
import 'dart:async';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../Feature/high/view/answer_widgets.dart';
import '../../../Feature/high/view/high_mission.dart';
import 'widgets/hourglass_timer_bar.dart';

class HighAnswer extends StatefulWidget {
  final MissionAnswer answer; //답안 데이터
  final DateTime gameStartTime; //게임시작시간
  final List<MissionQuestion> questionList; //문제 목록
  final int currentIndex; //현재 문제 인덱스

  const HighAnswer({
    super.key,
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
  });

  @override
  State<HighAnswer> createState() => _HighAnswerState();
}

//상태 관리
//1. 타이머 관리
//2. 시간 계산 thinkingTime, body time
class _HighAnswerState extends State<HighAnswer> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.gameStartTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.gameStartTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get thinkingTime {
    final minutes = _elapsed.inMinutes;
    final seconds = _elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get bodyTime {
    final totalSeconds = _elapsed.inSeconds;
    final c = totalSeconds ~/ 60;
    final d = (totalSeconds % 60) ~/ 5;
    return '$c년, $d개월';
  }

  List<InlineSpan> parseExplanation(String explanation, double fontSize) {
    final regex = RegExp(r'\$(.+?)\$');
    final matches = regex.allMatches(explanation);
    List<InlineSpan> spans = [];
    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: explanation
                .substring(lastEnd, match.start)
                .replaceAll('\\\\', '\\'),
            style: TextStyle(fontSize: fontSize, color: Colors.black87),
          ),
        );
      }
      final latex = match.group(1)!.replaceAll('\\\\', '\\');
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(
            latex,
            textStyle: TextStyle(fontSize: fontSize + 2, color: Colors.black87),
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < explanation.length) {
      spans.add(
        TextSpan(
          text: explanation.substring(lastEnd).replaceAll('\\\\', '\\'),
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
        ),
      );
    }
    return spans;
  }

  String _getButtonText() {
    // 진리3 페이지인지 확인 (문제 3번의 진리 페이지)
    if (widget.answer.title.endsWith('_3') || widget.answer.title == '진리_3') {
      return '다음 문제로';
    }
    // 힌트 문제인지 확인 (A, B 등으로 끝나는 경우)
    else if (widget.answer.title.endsWith('_A') ||
        widget.answer.title.endsWith('_B')) {
      return '돌아가기';
    } else {
      // 일반 문제의 경우
      if (widget.currentIndex + 1 < widget.questionList.length) {
        return '다음 문제로';
      } else {
        return '마지막 문제';
      }
    }
  }

  void _showGameCompletionDialog() {
    final totalTime = DateTime.now().difference(widget.gameStartTime);
    final minutes = totalTime.inMinutes;
    final seconds = totalTime.inSeconds % 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 완료!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('모든 문제를 완료했습니다!'),
              const SizedBox(height: 16),
              Text(
                '총 소요 시간: ${minutes}분 ${seconds}초',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // HighAnswer 닫기
                Navigator.of(context).pop(); // HighMission 닫기 (메인 화면으로 돌아가기)
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void handleNextButton() {
    final answerId = widget.answer.id;

    // 진리3 페이지인지 확인 (문제 3번의 진리 페이지)
    if (widget.answer.title.endsWith('_3') || widget.answer.title == '진리_3') {
      // 문제 3번의 진리 페이지에서 다음 문제로 버튼을 누르면 문제 4번으로 이동
      final idx = widget.questionList.indexWhere((qq) => qq.id == 6);
      if (idx != -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: idx,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      }
    }
    // 힌트 문제인지 확인 (A, B 등으로 끝나는 경우)
    else if (widget.answer.title.endsWith('_A') ||
        widget.answer.title.endsWith('_B')) {
      // 힌트 문제의 경우 원래 문제로 돌아가기
      // A는 문제 1번으로, B는 문제 3번으로 돌아가기
      int targetQuestionId;
      if (widget.answer.title.endsWith('_A')) {
        targetQuestionId = 1; // 문제 1번
      } else if (widget.answer.title.endsWith('_B')) {
        targetQuestionId = 4; // 문제 3번 (id: 4)
      } else {
        targetQuestionId = answerId - 1; // 기본적으로 이전 문제로
      }

      final idx = widget.questionList.indexWhere(
        (qq) => qq.id == targetQuestionId,
      );
      if (idx != -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: idx,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      }
    } else {
      // 일반 문제의 경우 다음 문제로 이동
      // 진리_1 페이지인 경우 문제 2번으로 직접 이동
      if (widget.answer.title == '진리_1') {
        final idx = widget.questionList.indexWhere(
          (qq) => qq.id == 3,
        ); // 문제 2번 (id: 3)
        if (idx != -1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HighMission(
                questionList: widget.questionList,
                currentIndex: idx,
                gameStartTime: widget.gameStartTime,
              ),
            ),
          );
        }
      } else if (widget.currentIndex + 1 < widget.questionList.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: widget.currentIndex + 1,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      } else {
        // 마지막 문제 완료 - 게임 종료 처리
        _showGameCompletionDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 0.045;

    // 문제 3번의 진리 페이지인지 확인 (숫자 3으로 끝나는 경우)
    final isQuestion3Truth = widget.answer.title.endsWith('_3');

    if (isQuestion3Truth) {
      // 문제 3번의 진리 페이지 - 새로운 디자인
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
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
                // 설명 텍스트 (퓨리 이미지 + 텍스트) - 기존과 동일
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
                // 진리3 콘텐츠 - 캡쳐 이미지와 동일하게
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // 연한 회색 배경
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 진리 3 제목
                        Text(
                          '진리 3',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 설명 텍스트
                        Text(
                          '측지선은 평면 또는 곡면에서 두 점을 연결하는 최단 거리를 의미한다. 평면에서의 측지선은 학교에서 배우는 직선(선분)을 의미한다. 곡면에서의 측지선은 학교에서 배우는 곡선처럼 보이지만 평면에서의 직선과 같은 의미를 가진다.',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 문구의 단서 3 섹션 (진한 회색 박스)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B6B6B), // 진한 회색
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '문구의 단서 3',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '정수(整數): 양의 정수(자연수), 0, 음의 정수의 집합',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // 다음 문제로 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: handleNextButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F55A7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _getButtonText(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 하단 모래시계 타이머 - 기존과 동일
                HourglassTimerBar(
                  mainColor: const Color(0xFF3F55A7),
                  think: thinkingTime,
                  body: bodyTime,
                  progress: 0.0,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // 문제 1, 2번의 진리 페이지 - 기존 디자인 복원
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DescriptionLevelBox(
                description: widget.answer.description,
                level: widget.answer.level,
                fontSize: screenWidth * 0.035,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                widget.answer.title,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              ExplanationBox(
                explanationSpans: parseExplanation(
                  widget.answer.explanation,
                  screenWidth * 0.05,
                ),
                answerImage: widget.answer.answerImage,
                fontSize: screenWidth * 0.05,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(height: screenHeight * 0.025),
              ClueBox(
                clueTitle: widget.answer.clueTitle,
                clue: widget.answer.clue,
                fontSize: screenWidth * 0.05,
              ),
              SizedBox(height: screenHeight * 0.01),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: handleNextButton,
                  child: Text(
                    _getButtonText(),
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: HourglassTimerBar(
                  mainColor: const Color(0xFF3F55A7),
                  think: thinkingTime,
                  body: bodyTime,
                  progress: 0.0, // 답안 화면에서는 진행률 표시 안함
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      );
    }
  }
}
