import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:math_escape/widgets/elementary_high_hint_popup.dart';
import 'package:math_escape/widgets/elementary_high_answer_popup.dart';

// MissionItem class as provided in the original code
class MissionItem {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final String hint1;
  final String hint2;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint1,
    required this.hint2,
  });

  factory MissionItem.fromJson(Map<String, dynamic> json) {
    List<String> parsedAnswer;
    if (json['answer'] is List) {
      parsedAnswer = List<String>.from(json['answer']);
    } else if (json['answer'] is String) {
      parsedAnswer = [json['answer'].toString().trim()];
    } else {
      parsedAnswer = [''];
    }

    return MissionItem(
      id: json['id'],
      title: json['title'],
      question: json['question'],
      answer: parsedAnswer,
      hint1: json['hint1'],
      hint2: json['hint2'],
    );
  }
}

class ElementaryHighMissionScreen extends StatefulWidget {
  const ElementaryHighMissionScreen({super.key});

  @override
  State<ElementaryHighMissionScreen> createState() =>
      _ElementaryHighMissionScreenState();
}

class _ElementaryHighMissionScreenState
    extends State<ElementaryHighMissionScreen> {
  List<MissionItem> missionList = [];
  bool isLoading = true;
  final TextEditingController _answerController = TextEditingController();
  int currentQuestionIndex = 0;
  final int totalQuestions = 10;
  int hintCounter = 0; // 힌트 버튼 클릭 횟수를 추적하는 변수

  @override
  void initState() {
    super.initState();
    loadMissionData();
  }

  Future<void> loadMissionData() async {
    try {
      final String jsonString = await rootBundle
          .loadString('lib/data/elementary_high/elementary_high_question.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      setState(() {
        missionList = jsonList.map((e) => MissionItem.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading mission data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showHintDialog() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    setState(() {
      hintCounter++;
    });

    String title;
    String content;

    if (hintCounter == 1) {
      title = '첫 번째 힌트';
      content = currentMission.hint1;
    } else if (hintCounter == 2) {
      title = '마지막 힌트';
      content = currentMission.hint2;
    } else {
      // 힌트를 2번 이상 누른 경우, 마지막 힌트를 계속 보여줍니다.
      title = '마지막 힌트';
      content = currentMission.hint2;
    }

    showDialog(
      context: context,
      builder: (_) =>
          HintDialog(
            hintTitle: title,
            hintContent: content,
          ),
    );
  }

  void _submitAnswer() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    final String userAnswer = _answerController.text.trim();

    final bool correct = currentMission.answer.contains(userAnswer);

    showDialog(
      context: context,
      builder: (_) => AnswerPopup(
        isCorrect: correct,
        onNext: () {
          Navigator.pop(context); // 팝업 닫기
          if (correct) {
            setState(() {
              if (currentQuestionIndex < missionList.length - 1) {
                currentQuestionIndex++;
                _answerController.clear();
                hintCounter = 0;
              } else {
                Navigator.pop(context); // 마지막 문제면 화면 종료
              }
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (missionList.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("미션 데이터를 불러오는 데 실패했습니다.")),
      );
    }

    final MissionItem mission = missionList[currentQuestionIndex];
    final Color mainColor = const Color(0xffed668a);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // 키보드 올라와도 레이아웃 안 밀림
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffed668a)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '미션! 수사모의 수학 유산을 찾아서',
          style: TextStyle(
            color: Color(0xffed668a),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // 본문
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/banner.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: LinearProgressIndicator(
                              value: (currentQuestionIndex + 1) /
                                  totalQuestions,
                              backgroundColor: const Color(0xffe0e0e0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  mainColor),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '문제 ${currentQuestionIndex +
                                      1} / $totalQuestions',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffb73d5d),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  mission.question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333333),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                        color: const Color(0xffdcdcdc)),
                                  ),
                                  child: TextField(
                                    controller: _answerController,
                                    decoration: InputDecoration(
                                      hintText: '정답을 입력해 주세요.',
                                      hintStyle: const TextStyle(
                                          color: Color(0xffaaaaaa)),
                                      contentPadding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 16.0, vertical: 12.0),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0),
                                        borderSide: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0),
                                        borderSide: BorderSide(
                                            color: mainColor, width: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 하단 버튼 고정
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                    onPressed: _showHintDialog,
                    child: Text(
                      '힌트보기',
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: _submitAnswer,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          '정답제출',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Positioned(
                          right: 0,
                          child: Image.asset(
                            'assets/images/treasure_chest.png',
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}