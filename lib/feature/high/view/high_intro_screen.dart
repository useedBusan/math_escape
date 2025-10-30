import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_colors.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/views/home_alert.dart';
import '../../../feature/high/model/high_mission_question.dart';
import '../../../feature/high/view/high_mission.dart';
import '../../../core/widgets/volume_dropdown_panel.dart';
import '../../../core/services/audio_service.dart';

Future<List<MissionQuestion>> loadQuestionList() async {
  final String jsonString = await rootBundle.loadString('assets/data/high/high_level_question.json');
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
}

class HighIntroScreen extends StatefulWidget {
  const HighIntroScreen({super.key});

  @override
  State<HighIntroScreen> createState() => _HighIntroScreenState();
}

class _HighIntroScreenState extends State<HighIntroScreen> {
  final AudioService _audio = AudioService();

  final String introText = '''
눈을 떴다.

숨소리조차 낯설게 느껴지는 완벽한 정적.
어둡고, 차가운 바닥. 그리고 나 혼자.

혼란스러운 마음을 정리하기도 전에 
어디선가 목소리가 들린다.

이곳은 '역설, 혹은 모호함…
그리고 진리의 공간.'

Paratruth Space, PS라고 불리는 이 공간에서,
당신은 무엇이 진리인지, 무엇이 역설인지, 판단하기 어려울 것입니다.

이 곳을 벗어나는 유일한 방법은, 
수수께끼같은 문구를 해석하는 것.

**‘인류의 처음 {#8352D9|정수}의 {#5298D9|정수}는 한 개인의 처음 {#D98A52|정수}를 만들기 위해 가장 기본이 되는 것, 곧 {#D95276|정수}!’**

이 공간 안에 있는 역설, 혹은 모호함 안에서, 
여러분들이 진리를 찾아낸다면, 각 '정수'에 대한 단서를 제공하겠습니다.

부디 문구를 해석하여,
이 공간을 벗어나 행복하고, 평안한 일상으로 다시 돌아갈 수 있길 바랍니다.

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
    // 고등 인트로 음성 재생 (BGM 위로)
    _audio.playCharacterAudio('assets/audio/high/highIntro.mp3');
  }

  Widget buildNarrationText() {
    return RichText(
        text: TextSpan(
          style: const TextStyle(
            height: 1.6
          ),
          children: introText.toStyledSpans(fontSize: 16)
        )
    );
  }

  @override
  void dispose() {
    // 인트로 종료 시 캐릭터 음성 중단
    _audio.stopCharacter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomGray.lightGray,
      appBar: AppBar(
        title: Text(
          StudentGrade.high.appBarTitle,
          style: TextStyle(
            color: StudentGrade.high.mainColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: StudentGrade.high.mainColor, size: 28),
          onPressed: () async {
            final alertResult = await HomeAlert.show(context);
            if (alertResult == true && context.mounted) {
              // 인트로에서 밖으로 나갈 때 보이스 중단
              await _audio.stopCharacter();
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: StudentGrade.high.mainColor, size: 28),
            onPressed: () {
              HomeAlert.showAndNavigate(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final questionList = await loadQuestionList();
                        // 미션 진입 전 인트로 음성 중단
                        await _audio.stopCharacter();

                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              settings: const RouteSettings(name: 'HighMission'),
                              builder: (_) => HighMission(
                                questionList: questionList,
                                currentIndex: 0,
                                gameStartTime: DateTime.now(),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: CustomBlue.s500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        '게임 시작',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: SafeArea(
              child: Builder(
                builder: (iconContext) {
                  return GestureDetector(
                    onTap: () {
                      final RenderBox box = iconContext.findRenderObject() as RenderBox;
                      final Offset iconOffset = box.localToGlobal(Offset.zero);
                      final Size iconSize = box.size;
                      final Size screenSize = MediaQuery.of(iconContext).size;

                      final double panelTop = iconOffset.dy + iconSize.height + 10;
                      final double panelWidth = screenSize.width * 0.93;
                      final double panelLeft = (screenSize.width - panelWidth) / 2;

                      showGeneralDialog(
                        context: iconContext,
                        barrierLabel: 'volumePanel',
                        barrierDismissible: true,
                        barrierColor: Colors.transparent,
                        transitionDuration: const Duration(milliseconds: 150),
                        pageBuilder: (context, a1, a2) {
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: GestureDetector(onTap: () => Navigator.of(context).pop()),
                              ),
                              Positioned(
                                top: panelTop,
                                left: panelLeft,
                                child: Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: panelWidth,
                                    child: VolumeDropdownPanel(
                                      onClose: () => Navigator.of(context).pop(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/images/common/soundControlIcon.png',
                      width: 28,
                      height: 28,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
