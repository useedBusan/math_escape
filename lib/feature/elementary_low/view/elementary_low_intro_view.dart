import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/services/service_locator.dart';
import '../../../core/views/common_intro_view.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/viewmodels/intro_view_model.dart';
import 'elementary_low_mission_view.dart';

class ElementaryLowIntroView extends StatefulWidget {
  const ElementaryLowIntroView({super.key});

  @override
  State<ElementaryLowIntroView> createState() => _ElementaryLowIntroViewState();
}

class _ElementaryLowIntroViewState extends State<ElementaryLowIntroView> {
  final viewModel = IntroViewModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel.loadTalks('assets/data/elem_low/elem_low_intro.json').then((_) {
      setState(() {
        isLoading = false;
      });

      if (viewModel.talks.isNotEmpty) {
        final firstVoice = viewModel.talks[0].voice;
        if (firstVoice != null && firstVoice.isNotEmpty) {
          serviceLocator.audioService.playCharacterAudio(firstVoice);
        }
      }
    });
  }

  @override
  void dispose() {
    // 대화 오버레이 초기 보이스와 경합을 막기 위해 여기서는 보이스 중단을 하지 않습니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Properties
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.talks.isEmpty) {
      return const Scaffold(body: Center(child: Text('표시할 항목이 없습니다.')));
    }

    String speakerName() {
      switch (viewModel.currentTalk.speaker) {
        case Speaker.puri:
          return "푸리";
        case Speaker.maemae:
          return "매매";
        case Speaker.both:
          return "푸리 & 매매";
        case Speaker.book:
          return "수첩";
      }
    }

    return CommonIntroView(
      appBarTitle: StudentGrade.elementaryLow.appBarTitle,
      backgroundAssetPath: viewModel.currentTalk.backImg,
      characterImageAssetPath: viewModel.currentTalk.speakerImg,
      speakerName: speakerName(),
      talkText: viewModel.currentTalk.talk,
      buttonText: "다음",
      grade: StudentGrade.elementaryLow,
      lottieAnimationPath: viewModel.currentIdx == 0 ? 'assets/animations/furiAppearance.json' : null,
      lottieRepeat: false,
      onNext: () {
        if (viewModel.canGoNext()) {
          setState(() {
            viewModel.goToNextTalk();
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const ElementaryLowMissionView(),
            ),
          );
        }
      },
      onBack: () {
        if (viewModel.canGoPrevious()) {
          setState(() {
            viewModel.goToPreviousTalk();
          });
        } else {
          // 인트로에서 밖으로 나갈 때 보이스 중단
          serviceLocator.audioService.stopCharacter();
          Navigator.of(context).pop();
        }
      },
    );
  }
}