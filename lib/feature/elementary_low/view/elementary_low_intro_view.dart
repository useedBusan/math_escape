import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
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
    });
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
      appBarTitle: "미션! 수학자의 수첩을 찾아서",
      backgroundAssetPath: viewModel.currentTalk.backImg,
      characterImageAssetPath: viewModel.currentTalk.speakerImg,
      speakerName: speakerName(),
      talkText: viewModel.currentTalk.talk,
      buttonText: "다음",
      grade: StudentGrade.elementaryLow,
      // 첫 번째 화면에만 furiAppearance 애니메이션 표시 (한 번만 재생)
      lottieAnimationPath: viewModel.currentIdx == 0 ? 'assets/animations/furiAppearance.json' : null,
      showLottieInsteadOfImage: viewModel.currentIdx == 0,
      lottieRepeat: false, // furiAppearance는 한 번만 재생
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
          // Intro의 첫 번째 화면에서 뒤로가기 시 홈으로 이동
          Navigator.of(context).pop();
        }
      },
    );
  }
}