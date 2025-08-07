import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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

  void _showHintDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기',
                style: TextStyle(color: Color(0xffed668a))),
          ),
        ],
      ),
    );
  }

  void _submitAnswer() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    final String userAnswer = _answerController.text.trim();
    if (currentMission.answer.contains(userAnswer)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('정답!'),
          content: const Text('정답입니다! 다음 문제로 넘어갑니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (currentQuestionIndex < missionList.length - 1) {
                    currentQuestionIndex++;
                    _answerController.clear();
                  } else {
                    // 모든 미션 완료
                    Navigator.pop(context);
                  }
                });
              },
              child: const Text('다음',
                  style: TextStyle(color: Color(0xffed668a))),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('오답'),
          content: const Text('다시 한번 생각해보세요!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인',
                  style: TextStyle(color: Color(0xffed668a))),
            ),
          ],
        ),
      );
    }
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
      body: Stack(
        children: [
          // 스크롤 가능한 메인 콘텐츠 영역
          SingleChildScrollView(
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
                    children: [ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: LinearProgressIndicator(
                        value: (currentQuestionIndex + 1) / totalQuestions,
                        backgroundColor: const Color(0xffe0e0e0),
                        valueColor: AlwaysStoppedAnimation<Color>(mainColor),
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
                              '문제 ${currentQuestionIndex + 1} / $totalQuestions',
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
                                  color: const Color(0xffdcdcdc))
                              ),
                              child: TextField(
                                controller: _answerController,
                                decoration: InputDecoration(
                                  hintText: '정답을 입력해 주세요.',
                                  hintStyle: const TextStyle(color: Color(0xffaaaaaa)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                    BorderSide(color: mainColor, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50), // 하단 버튼과의 여백
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 하단에 고정된 버튼 영역
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 100.0),
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
                        onPressed: () => _showHintDialog('힌트 보기', mission.hint1),
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
                              child: Image.asset('assets/images/treasure_chest.png', height: 40),
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
        ],
      ),
    );
  }
}