import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../mission/high/high_mission.dart';
import '../../models/high/high_mission_question.dart';

Future<List<MissionQuestion>> loadQuestionList() async {
  final String jsonString = await rootBundle.loadString('lib/data/high_level_question.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
}

class HighIntroScreen extends StatefulWidget {
  const HighIntroScreen({super.key});

  @override
  State<HighIntroScreen> createState() => _HighIntroScreenState();
}

class _HighIntroScreenState extends State<HighIntroScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  final String introText = '''
눈을 떴다.

숨소리조차 낯설게 느껴지는 완벽한 정적.
어둡고, 차가운 바닥. 그리고 나 혼자.

혼란스러운 마음을 정리하기도 전에 
어디선가 목소리가 들린다.

이곳은 '역설, 혹은 모호함… 그리고 진리의 공간.'

Paratruth Space, PS라고 불리는 이 공간에서, 
당신은 무엇이 진리인지, 무엇이 역설인지, 
판단하기 어려울 것입니다.

이 곳을 벗어나는 유일한 방법은, 
수수께끼같은 문구를 해석하는 것.

'인류의 처음 정수의 정수는 한 개인의 ,
처음 정수를 만들기 위해 가장 기본이 되는 것,  
곧, 정수!'

이 공간 안에 있는 역설, 혹은 모호함 안에서, 
여러분들이 진리를 찾아낸다면, 각 '정수'에 대한 
단서를 제공하겠습니다.

부디 문구를 해석하여, 이 공간을 벗어나 
여러분들이 행복하고, 평안한 일상으로 
다시 돌아갈 수 있길 바랍니다.

다만, 한 가지 알아둬야 할 사실이 있습니다.
이 공간에서는, 당신의 생각의 속도에 비해, 
몸은 빠르게 늙어갑니다.

여기에서 1분간 생각하는 동안, 
당신의 몸은 1년 나이들게 될 것입니다.

당신이 100세 이상을 살기를 기대하기에, 
생각의 시간으로 90분을 제공하겠습니다.

가능하다면 빨리 벗어나길 응원합니다.
''';

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  Future<void> initAudioPlayer() async {
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  Future<void> playIntro() async {
    try {
      await audioPlayer.play(AssetSource('audio/high_intro_sound.mp3'));
    } catch (e) {
      print('오디오 재생 오류: $e');
    }
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }

  Widget buildNarrationText() {
    return Text(
      introText,
      style: const TextStyle(
        fontSize: 18,
        height: 1.6,
        color: Color(0xFFE9D7CE),
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6E6764),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Intro',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      buildNarrationText(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: isPlaying ? null : playIntro,
                            child: Text(isPlaying ? "재생 중..." : "나레이션 듣기"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: stopAudio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            child: const Text("정지"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final questionList = await loadQuestionList();
                    stopAudio();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HighMission(
                          questionList: questionList,
                          currentIndex: 0,
                          gameStartTime: DateTime.now(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    '게임 시작',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
