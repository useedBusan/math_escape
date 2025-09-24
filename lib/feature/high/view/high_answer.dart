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

  void handleNextButton() {
    final title = widget.answer.title;
    if (title == '역설, 혹은 모호함_A' || title == '진리_A') {
      final idx = widget.questionList.indexWhere((qq) => qq.id == 1);
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
    } else if (title == '역설, 혹은 모호함_1' || title == '진리_1') {
      final idx = widget.questionList.indexWhere((qq) => qq.id == 3);
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
                  widget.answer.title == '역설, 혹은 모호함_A' ||
                          widget.answer.title == '진리_A'
                      ? '돌아가기'
                      : (widget.answer.title == '역설, 혹은 모호함_1' ||
                            widget.answer.title == '진리_1')
                      ? '다음 문제로'
                      : (widget.currentIndex + 1 < widget.questionList.length
                            ? '다음 문제로'
                            : '마지막 문제'),
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
