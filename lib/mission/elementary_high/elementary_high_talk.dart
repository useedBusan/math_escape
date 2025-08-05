import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 대화 모델
class TalkItem {
  final int id;
  final String talk;
  final String answer;

  TalkItem({required this.id, required this.talk, required this.answer});

  factory TalkItem.fromJson(Map<String, dynamic> json) {
    return TalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'],
    );
  }
}

class ElementaryHighTalkScreen extends StatefulWidget {
  const ElementaryHighTalkScreen({super.key});

  @override
  State<ElementaryHighTalkScreen> createState() => _ElementaryHighTalkScreenState();
}

class _ElementaryHighTalkScreenState extends State<ElementaryHighTalkScreen> {
  List<TalkItem> talkList = [];
  int currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTalks();
  }

  Future<void> loadTalks() async {
    final String jsonString = await rootBundle.loadString('lib/data/elementary_high/elementary_high_context.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      talkList = jsonList.map((e) => TalkItem.fromJson(e)).toList();
      isLoading = false;
    });
  }

  void goToNext() {
    if (currentIndex < talkList.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // 마지막 대화 이후, 예: 문제풀이 화면으로 이동
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ElementaryHighMission()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final talk = talkList[currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('푸리와 매매의 수학 보물 대탐험'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xffed668a),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffed668a)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/bsbackground.png',
              fit: BoxFit.cover,
            ),
          ),
          // 2. 그라데이션 오버레이
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x99ED668A), // #ED668A, 60% 투명도
                    Color(0x99FFFFFF), // #FFFFFF, 60% 투명도
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // 3. 나머지 UI
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Flexible(
                  flex: 6,
                  child: Center(
                    child: Image.asset(
                      'assets/images/puri_stand.png', // 실제 경로에 맞게 수정
                      height: 280,
                    ),
                  ),
                ),
                const SizedBox(height: 4), // 간격 최소화
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 대화 박스
                      Container(
                        width: double.infinity,
                        height: 200, // 더 길게
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xffed668a), width: 1.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [],
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            talk.talk,
                            style: const TextStyle(fontSize: 17, color: Colors.black87, height : 1.5),
                          ),
                        ),
                      ),
                      // 푸리 이름 박스
                      Positioned(
                        top: 0,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xffb73d5d),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                          child: const Text(
                            '푸리',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24), // 아래 여백 추가
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffed668a),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: goToNext,
                      child: Text(
                        talk.answer,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}