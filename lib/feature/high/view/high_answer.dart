import 'package:flutter/material.dart';
import 'dart:async';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../Feature/high/view/answer_widgets.dart';
import '../../../Feature/high/view/high_mission.dart';
import 'widgets/hourglass_timer_bar.dart';

class HighAnswer extends StatefulWidget {
  final MissionAnswer answer;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;
  final int currentIndex;

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
      if (widget.currentIndex + 1 < widget.questionList.length) {
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
        backgroundColor: const Color(0xFFF5F5F5), // 연한 회색 배경
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 진리 제목
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '진리 3', // 간단한 제목
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 설명 박스 (간소화)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '문제 3번의 정답과 설명이 여기에 표시됩니다.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 문구의 단서 섹션 (진한 회색 컨테이너)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B6B6B), // 진한 회색
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '진리 문구의 단서 3', // 간단한 제목
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '문구의 단서 내용이 여기에 표시됩니다.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 다음 문제로 버튼
              Center(
                child: ElevatedButton(
                  onPressed: handleNextButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F55A7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('다음 문제로', style: TextStyle(fontSize: fontSize)),
                ),
              ),
              SizedBox(height: 24),

              // 하단 모래시계 타이머
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
                clueTitle: widget.answer.clueTitle ?? '문구의 단서',
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
