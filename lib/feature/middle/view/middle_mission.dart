import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/core/utils/view/hint_popup.dart';
import 'dart:convert';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/answer_popup.dart';

// 새로운 모델 클래스 추가
class CorrectTalkItem {
  final int id;
  final List<TalkItem> talks;

  CorrectTalkItem({required this.id, required this.talks});

  factory CorrectTalkItem.fromJson(Map<String, dynamic> json) {
    return CorrectTalkItem(
      id: json['id'],
      talks: (json['talks'] as List)
          .map((talk) => TalkItem.fromJson(talk))
          .toList(),
    );
  }
}

class TalkItem {
  final String talk;
  final String puri_image;
  final String back_image;

  TalkItem({
    required this.talk,
    required this.puri_image,
    required this.back_image,
  });

  factory TalkItem.fromJson(Map<String, dynamic> json) {
    return TalkItem(
      talk: json['talk'],
      puri_image: json['puri_image'],
      back_image: json['back_image'],
    );
  }
}

class MissionItem {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final String hint1;
  final String hint2;
  final String back_image;
  final String questionImage;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint1,
    required this.hint2,
    required this.back_image,
    required this.questionImage,
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
      back_image: json['back_image'] ?? '',
      questionImage: json['questionImage'] ?? '',
    );
  }
}

// TalkScreen 위젯
class TalkScreen extends StatelessWidget {
  final TalkItem talk;
  final VoidCallback onNext;

  const TalkScreen({super.key, required this.talk, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Center(
                  child: Text(
                    '수학자의 비밀 노트를 찾아라!',
                    style: TextStyle(
                      color: Color(0xff3F55A7),
                      fontSize: MediaQuery.of(context).size.width * (16 / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF3F55A7),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
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
              talk.back_image.isNotEmpty
                  ? talk.back_image
                  : 'assets/images/bsbackground.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.75), // 위쪽 (36%)
                    Color.fromRGBO(0, 0, 0, 0.50), // 아래쪽 (20%)
                  ],
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
                      height: MediaQuery.of(context).size.height * 0.24,
                      fit: BoxFit.contain,
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
                        height: MediaQuery.of(context).size.height * 0.32,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff172D7F),
                            width: 1.5,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            talk.talk,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width *
                                  (15 / 360),
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff2B4193),
                            border: Border.all(
                              color: const Color(0xffffffff),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            '푸리',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width *
                                  (16 / 360),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_circle,
                            color: Color(0xFF101351),
                            size: 32,
                          ),
                          onPressed: onNext,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MiddleMissionScreen
class MiddleMissionScreen extends StatefulWidget {
  const MiddleMissionScreen({super.key});

  @override
  State<MiddleMissionScreen> createState() => _MiddleMissionScreenState();
}

class _MiddleMissionScreenState extends State<MiddleMissionScreen>
    with TickerProviderStateMixin {
  List<MissionItem> missionList = [];
  List<CorrectTalkItem> talkList = [];
  bool isLoading = true;
  final TextEditingController _answerController = TextEditingController();
  int currentQuestionIndex = 0;
  final int totalQuestions = 10;
  int hintCounter = 0;
  late AnimationController _hintColorController;
  late Animation<double> _hintColorAnimation;

  // 힌트 카드 표시 상태 추가
  bool showHint1 = false;
  bool showHint2 = false;

  @override
  void initState() {
    super.initState();
    loadMissionData();

    _hintColorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _hintColorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hintColorController, curve: Curves.easeInOut),
    );

    _hintColorController.repeat(reverse: true);
  }

  Future<void> loadMissionData() async {
    try {
      final String missionJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_question.json',
      );
      final List<dynamic> missionJsonList = json.decode(missionJsonString);

      final String talkJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_correct_talks.json',
      );
      final List<dynamic> talkJsonList = json.decode(talkJsonString);

      setState(() {
        missionList = missionJsonList
            .map((e) => MissionItem.fromJson(e))
            .toList();
        talkList = talkJsonList
            .map((e) => CorrectTalkItem.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading mission data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showHintDialog() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    hintCounter++;

    switch (hintCounter) {
      case 1:
        setState(() {
          showHint1 = true;
        });
        break;
      case 2:
        setState(() {
          showHint2 = true;
        });
        break;
      default:
        setState(() {
          hintCounter = 0;
        });
    }
  }


  void _submitAnswer() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    final String userAnswer = _answerController.text.trim();
    final bool correct = currentMission.answer.contains(userAnswer);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnswerPopup(
        isCorrect: correct,
        onNext: () {
          Navigator.pop(context);
          if (correct) {
            _showCorrectAnswerDialog();
          }
        }, grade: StudentGrade.middle,
      ),
    );
  }

  @override
  void dispose() {
    _hintColorController.dispose();
    super.dispose();
  }

  void _goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < missionList.length - 1) {
        currentQuestionIndex++;
        _answerController.clear();
        hintCounter = 0;
        // 다음 문제로 넘어갈 때 힌트 카드 상태 초기화
        showHint1 = false;
        showHint2 = false;
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _showCorrectAnswerDialog() {
    try {
      final int currentQuestionId = currentQuestionIndex + 1;
      final CorrectTalkItem correctTalk = talkList.firstWhere(
        (talk) => talk.id == currentQuestionId,
      );

      int currentTalkIndex = 0;

      void showNextTalk() {
        if (currentTalkIndex < correctTalk.talks.length) {
          final TalkItem talk = correctTalk.talks[currentTalkIndex];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TalkScreen(
                talk: talk,
                onNext: () {
                  Navigator.pop(context);
                  currentTalkIndex++;
                  if (currentTalkIndex < correctTalk.talks.length) {
                    showNextTalk();
                  } else {
                    if (currentQuestionId == 10) {
                      Navigator.of(context).pop();
                    } else {
                      _goToNextQuestion();
                    }
                  }
                },
              ),
            ),
          );
        } else {
          // 대화가 없는 경우 (10번 문제)
          if (currentQuestionId == 10) {
            // 10번 문제를 맞췄다면 메인화면으로
            Navigator.of(context).pop();
          } else {
            // 다른 문제라면 다음 문제로
            _goToNextQuestion();
          }
        }
      }

      showNextTalk();
    } catch (e) {
      print("Error finding talk for question ${currentQuestionIndex + 1}: $e");
      _goToNextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (missionList.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("미션 데이터를 불러오는 데 실패했습니다.")),
      );
    }

    final MissionItem mission = missionList[currentQuestionIndex];
    final Color mainColor = const Color(0xFF3F55A7);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F55A7)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '수학자의 비밀 노트를 찾아라!',
          style: TextStyle(
            color: const Color(0xFF3F55A7),
            fontSize: MediaQuery.of(context).size.width * (16 / 360),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              mission.back_image.isNotEmpty
                  ? mission.back_image
                  : 'assets/images/bsbackground.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.75),
                    Color.fromRGBO(0, 0, 0, 0.50),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 14),
                Column(
                  children: [
                    Text(
                      '각 문제마다 2개의 힌트가 있어.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "SBAggro",
                        fontSize:
                            MediaQuery.of(context).size.width * (14 / 360),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFF2F2F2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '2개의 힌트를 활용해 수학자의 비밀 노트를 찾아내자!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "SBAggro",
                        fontSize:
                            MediaQuery.of(context).size.width * (14 / 360),
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFF2F2F2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // 첫번째 레이어
                      Container(
                        width: MediaQuery.of(context).size.width - 60,
                        height: MediaQuery.of(context).size.height * 0.5,
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF192243),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF192243),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      // 두번째 레이어
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height * 0.5,
                        margin: const EdgeInsets.only(top: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F55A7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF192243),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      // 세번째 레이어 (실제 콘텐츠 카드)
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height * 0.5,
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                        margin: const EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF192243),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 문제 번호 + 힌트 버튼
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '문제 ${currentQuestionIndex + 1} / $totalQuestions',
                                  style: TextStyle(
                                    fontFamily: "SBAggro",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        (18 / 360),
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff202020),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _hintColorAnimation,
                                      builder: (context, child) {
                                        final color = Color.lerp(
                                          const Color(0xFF3F55A7),
                                          const Color(0xFFB2BBDC),
                                          _hintColorAnimation.value,
                                        )!;
                                        return IconButton(
                                          icon: Icon(
                                            Icons.help_outline,
                                            color: color,
                                          ),
                                          onPressed: _showHintDialog,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          iconSize: 28,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    AnimatedBuilder(
                                      animation: _hintColorAnimation,
                                      builder: (context, child) {
                                        final color = Color.lerp(
                                          const Color(0xFF3F55A7),
                                          const Color(0xFFB2BBDC),
                                          _hintColorAnimation.value,
                                        )!;
                                        return Transform.translate(
                                          offset: const Offset(0, -15),
                                          child: Text(
                                            '힌트',
                                            style: TextStyle(
                                              color: color,
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  (12 / 360),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // 문제 영역
                            Text(
                              mission.question,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.width *
                                    (16 / 360),
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 이미지 영역 (이미지가 있을때만)
                            if (mission.questionImage.isNotEmpty)
                              if (mission.questionImage.startsWith('assets/'))
                                ClipRRect(
                                  child: Image.asset(
                                    mission.questionImage,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF),
                                    border: Border.all(
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  child: Text(
                                    mission.questionImage,
                                    style: TextStyle(
                                      fontFeatures: [FontFeature.fractions()],
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          (16 / 360),
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                            const Expanded(child: SizedBox()),
                            // 텍스트필드
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: const Color(0xffdcdcdc),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            (15 / 360),
                                      ),
                                      controller: _answerController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintText: '정답을 입력해 주세요.',
                                        hintStyle: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              (14 / 360),
                                          color: const Color(0xffaaaaaa),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12.0,
                                              vertical: 12.0,
                                            ),
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: _submitAnswer,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: mainColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              (14 / 360),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 힌트 카드
                // if (showHint1 || showHint2) ...[
                const SizedBox(height: 20),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 힌트 1
                        AnimatedSlide(
                          duration: showHint1
                              ? const Duration(milliseconds: 300)
                              : Duration.zero,
                          curve: Curves.easeOut,
                          offset: showHint1
                              ? Offset.zero
                              : const Offset(0, 0.1),
                          child: AnimatedOpacity(
                            duration: showHint1
                                ? const Duration(milliseconds: 300)
                                : Duration.zero,
                            opacity: showHint1 ? 1.0 : 0.0,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * (16 / 360),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFEBEBEB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '단서#1 : 목적지의 비밀',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          (14 / 360),
                                      fontFamily: "SBAggro",
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF101351),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width *
                                        (8 / 360),
                                  ),
                                  Text(
                                    mission.hint1,
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          (13 / 360),
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        if (showHint1 && showHint2)
                          SizedBox(
                            height:
                                MediaQuery.of(context).size.width * (12 / 360),
                          ),

                        // 힌트 2
                        AnimatedSlide(
                          duration: showHint2
                              ? const Duration(milliseconds: 300)
                              : Duration.zero,
                          curve: Curves.easeOut,
                          offset: showHint2
                              ? Offset.zero
                              : const Offset(0, 0.1),
                          child: AnimatedOpacity(
                            duration: showHint2
                                ? const Duration(milliseconds: 300)
                                : Duration.zero,
                            opacity: showHint2 ? 1.0 : 0.0,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * (16 / 360),
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                border: Border.all(
                                  color: const Color(0xFFEBEBEB),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '단서#2 : 마지막 열쇠',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          (14 / 360),
                                      fontFamily: "SBAggro",
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF101351),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width *
                                        (8 / 360),
                                  ),
                                  Text(
                                    mission.hint2,
                                    style: TextStyle(
                                      fontFamily: "Pretendard",
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                          (13 / 360),
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
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
          ),
        ],
      ),
    );
  }
}
