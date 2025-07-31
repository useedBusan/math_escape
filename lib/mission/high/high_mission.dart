//고등학생 미션 화면 구현

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/models/high/high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/models/high/high_mission_answer.dart';
import 'package:math_escape/mission/high/high_answer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:math_escape/screens/qr_scan_screen.dart';
import 'package:math_escape/widgets/answer_popup.dart';
import 'package:math_escape/mission/high/high_mission_constants.dart';
import 'package:math_escape/mission/high/widgets.dart';

class HighMission extends StatefulWidget {
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
  State<HighMission> createState() => _HighMissionState();
}

class _HighMissionState extends State<HighMission> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.gameStartTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
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

  Future<MissionAnswer> loadAnswerById(int id) async {
    final String jsonString = await rootBundle.loadString('lib/data/high_level_answer.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => MissionAnswer.fromJson(e))
        .firstWhere((a) => a.id == id);
  }

  Future<List<MissionQuestion>> loadQuestionList() async {
    final String jsonString = await rootBundle.loadString('lib/data/high_level_question.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
  }

  Future<void> showAnswerPopup(BuildContext context, {required bool isCorrect}) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AnswerPopup(isCorrect: isCorrect),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final q = widget.questionList[widget.currentIndex];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(q.title, style: TextStyle(fontSize: screenWidth * 0.05)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: screenWidth * 0.04,
              right: screenWidth * 0.04,
              top: screenWidth * 0.04,
              bottom: screenHeight * 0.18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DescriptionLevelBox(
                  description: q.description,
                  level: q.level,
                  fontSize: screenWidth * 0.035,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  q.title,
                  style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.015),
                QuestionBalloon(
                  question: q.question,
                  fontSize: screenWidth * 0.04,
                ),
                SizedBox(height: screenHeight * 0.025),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('답변:', style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold)),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: '정답을 입력하세요',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                if (q.title == '역설, 혹은 모호함_B') ...[
                  SizedBox(height: screenHeight * 0.01),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text('QR코드 촬영', style: TextStyle(fontSize: screenWidth * 0.04)),
                      onPressed: () async {
                        final status = await Permission.camera.request();
                        if (status.isGranted) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QRScanScreen(),
                            ),
                          );
                          if (result != null && result is String) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('QR 코드 결과: $result')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('카메라 권한이 필요합니다.')),
                          );
                        }
                      },
                    ),
                  ),
                ],
                SizedBox(height: screenHeight * 0.015),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final input = _controller.text.trim().toLowerCase();
                        final answers = q.answer.map((a) => a.trim().toLowerCase()).toList();
                        final isCorrect = answers.contains(input);
                        await showAnswerPopup(context, isCorrect: isCorrect);
                        if (isCorrect) {
                          final answerData = await loadAnswerById(q.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HighAnswer(
                                answer: answerData,
                                gameStartTime: widget.gameStartTime,
                                questionList: widget.questionList,
                                currentIndex: widget.currentIndex,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text('확인', style: TextStyle(fontSize: screenWidth * 0.04)),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                TextButton(
                  onPressed: () async {
                    if (q.title == '역설, 혹은 모호함_1') {
                      final idx = widget.questionList.indexWhere((qq) => qq.id == 2);
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
                    } else if (q.title == '역설, 혹은 모호함_3') {
                      final idx = widget.questionList.indexWhere((qq) => qq.id == 5);
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('힌트'),
                            content: Text(q.hint),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('힌트 보기', style: TextStyle(fontSize: screenWidth * 0.04)),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TimerInfoBox(
                thinkingTime: thinkingTime,
                bodyTime: bodyTime,
                fontSize: screenWidth * 0.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
