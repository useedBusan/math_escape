import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/mission/elementary_high/elementary_high_mission.dart';

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

    // answer가 List인지 String인지 확인 후 파싱
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

  @override
  void initState() {
    super.initState();
    loadMissionData();
  }

  Future<void> loadMissionData() async {
    final String jsonString = await rootBundle
        .loadString('lib/data/elementary_high/elementary_high_question.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    setState(() {
      missionList = jsonList.map((e) => MissionItem.fromJson(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final MissionItem mission = missionList[0]; // 하나만 보여줄 경우

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '수학 미션',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xffed668a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mission.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xffb73d5d),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              mission.question,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('힌트 1'),
                    content: Text(mission.hint1),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('힌트 1 보기'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('힌트 2'),
                    content: Text(mission.hint2),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('힌트 2 보기'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffed668a),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('정답'),
                    content: Text(mission.answer.first),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                '정답 확인',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
