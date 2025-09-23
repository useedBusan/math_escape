import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/custom_intro_alert.dart';
import '../../../Feature/middle/view/middle_mission.dart';
import '../../../core/utils/view/common_intro_view.dart';
import '../model/middle_intro_talk.dart';

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
  }

  void goToNext() {
    final int lastIndex = talkList.length - 1;
    final int alertIndex = lastIndex - 1; // 마지막 바로 전 대화에서 안내 후 이동

    if (currentIndex < alertIndex) {
      setState(() {
        currentIndex++;
        imageKey = UniqueKey();
      });
    } else if (currentIndex == alertIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomIntroAlert(
              onConfirm: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MiddleMissionScreen(),
                  ),
                );
              },
              grade: StudentGrade.middle,
            );
          },
        );
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MiddleMissionScreen()),
      );
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        imageKey = UniqueKey();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final talk = talkList[currentIndex];

    return CommonIntroView(
      appBarTitle: '수학자의 비밀 노트를 찾아라!',
      backgroundAssetPath: 'assets/images/common/bsbackground.png',
      characterImageAssetPath: talk.puriImage,
      speakerName: '푸리',
      talkText: talk.talk,
      buttonText: '다음',
      grade: StudentGrade.middle,
      onNext: goToNext,
      onBack: () {
        if (currentIndex > 0) {
          goToPrevious();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
