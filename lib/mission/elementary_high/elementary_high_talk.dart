import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'elementary_high_mission.dart';

// 대화 모델
class TalkItem {
  final int id;
  final String talk;
  final String answer;
  final String puri_image;

  TalkItem({
    required this.id,
    required this.talk,
    required this.answer,
    required this.puri_image,
  });

  factory TalkItem.fromJson(Map<String, dynamic> json) {
    return TalkItem(
      id: json['id'],
      talk: json['talk'],
      answer: json['answer'],
      puri_image: json['puri_image'],
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
      // 마지막 대화면 → 문제 페이지로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ElementaryHighMissionScreen()),
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

    final talk = talkList[currentIndex];

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          setState(() {
            currentIndex--;
          });
          return false; // 기본 뒤로가기 동작 막기
        } else {
          return true; // 첫 대화면일 때는 기본 동작 (이전 화면으로 이동)
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      '미션! 수사모의 수학 유산을 찾아서',
                      style: TextStyle(
                        color: Color(0xffed668a),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xffed668a)),
                      onPressed: () {
                        if (currentIndex > 0) {
                          setState(() {
                            currentIndex--;
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/bsbackground.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x99ED668A),
                      Color(0x99FFFFFF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
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
                        talk.puri_image,
                        height: 280,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          height: 200,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xffed668a), width: 1.5),
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              talk.talk,
                              style: const TextStyle(fontSize: 17, color: Colors.black87, height: 1.5),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xffb73d5d),
                              borderRadius: BorderRadius.circular(40),
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.93,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffed668a),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      ),
    );
  }
}
