import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/custom_intro_alert.dart';
import 'middle_mission.dart';
import '../../../core/views/common_intro_view.dart';
import '../model/middle_intro_talk.dart';
import '../../../core/services/service_locator.dart';

class MiddleIntroScreen extends StatefulWidget {
  const MiddleIntroScreen({super.key});

  @override
  State<MiddleIntroScreen> createState() => _MiddleIntroScreenState();
}

class _MiddleIntroScreenState extends State<MiddleIntroScreen>
    with WidgetsBindingObserver {
  List<IntroTalkItem> talkList = [];
  int currentIndex = 0;
  bool isLoading = true;

  Key imageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadTalks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // 보이스 중단
    serviceLocator.audioService.stopCharacter();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        imageKey = UniqueKey();
      });
    }
  }

  Future<void> loadTalks() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/middle/middle_intro.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      talkList = jsonList.map((e) => IntroTalkItem.fromJson(e)).toList();
      isLoading = false;
    });
    // 첫 항목 보이스 재생
    _playCurrentVoice();
  }

  void goToNext() {
    final int lastIndex = talkList.length - 1;
    final int alertIndex = lastIndex;

    if (currentIndex < alertIndex) {
      setState(() {
        currentIndex++;
        imageKey = UniqueKey();
      });
      _playCurrentVoice();
    } else if (currentIndex == alertIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // 위젯의 context를 미리 저장
        final navigatorContext = Navigator.of(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return CustomIntroAlert(
              onConfirm: () async {
                Navigator.of(dialogContext).pop();
                await serviceLocator.audioService.stopCharacter();
                // 오디오 플레이어가 완전히 정리될 때까지 잠시 대기
                await Future.delayed(const Duration(milliseconds: 100));
                if (mounted) {
                  navigatorContext.pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const MiddleMissionScreen(), // middle_mission.dart에서 import됨
                    ),
                  );
                }
              },
              grade: StudentGrade.middle,
            );
          },
        );
      });
    } else {
      serviceLocator.audioService.stopCharacter();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MiddleMissionScreen()), // middle_mission.dart에서 import됨
      );
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        imageKey = UniqueKey();
      });
      _playCurrentVoice();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _playCurrentVoice() {
    if (talkList.isEmpty) return;
    final String? voice = talkList[currentIndex].voice;
    if (voice == null || voice.isEmpty) {
      serviceLocator.audioService.stopCharacter();
      return;
    }
    serviceLocator.audioService.playCharacterAudio(voice);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final talk = talkList[currentIndex];

    return CommonIntroView(
      appBarTitle: StudentGrade.middle.appBarTitle,
      backgroundAssetPath: 'assets/images/common/bsbackground.webp',
      characterImageAssetPath: talk.puriImage,
      speakerName: '푸리',
      talkText: talk.talk,
      buttonText: '다음',
      grade: StudentGrade.middle,
      // 첫 번째 화면에만 furiAppearance 애니메이션 표시 (한 번만 재생)
      lottieAnimationPath: currentIndex == 0 ? 'assets/animations/furiAppearance.json' : null,
      lottieRepeat: false, // furiAppearance는 한 번만 재생
      onNext: goToNext,
      onBack: () {
        if (currentIndex > 0) {
          goToPrevious();
        } else {
          // 인트로에서 밖으로 나갈 때 보이스 중단
          serviceLocator.audioService.stopCharacter();
          Navigator.of(context).pop();
        }
      },
    );
  }
}
