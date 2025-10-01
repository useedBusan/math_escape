import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/answer_popup.dart';
import '../../../core/utils/view/common_intro_view.dart';
import '../../../core/utils/viewmodel/intro_view_model.dart';
import '../../../constants/enum/image_enums.dart';
import '../../../core/utils/image_path_validator.dart';
import '../coordinator/middle_mission_coordinator.dart';
import 'conversation_overlay.dart';

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
      puri_image: ImagePathValidator.validate(
        json['puri_image'] as String?,
        ImageAssets.furiGood.path,
        logInvalid: true,
      ),
      back_image: ImagePathValidator.validate(
        json['back_image'] as String?,
        ImageAssets.background.path,
        logInvalid: true,
      ),
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
  final List<String> options;
  final bool isqr;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint1,
    required this.hint2,
    required this.back_image,
    required this.questionImage,
    required this.options,
    this.isqr = false,
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
      options: List<String>.from(json['options'] ?? []),
      isqr: json['isqr'] as bool? ?? false,
    );
  }
}

  // 기존 TalkScreen은 공통 인트로 뷰로 대체됨

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

  // QR 인식 여부
  bool get isqr => missionList.isNotEmpty && currentQuestionIndex < missionList.length 
      ? missionList[currentQuestionIndex].isqr 
      : false;

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

  void _syncWithCoordinator(int coordinatorIndex) {
    if (coordinatorIndex != currentQuestionIndex) {
      setState(() {
        currentQuestionIndex = coordinatorIndex;
        _answerController.clear();
        hintCounter = 0;
        showHint1 = false;
        showHint2 = false;
      });
    }
  }

  Future<void> loadMissionData() async {
    try {
      final String missionJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_question.json',
      );
      final List<dynamic> missionJsonList = json.decode(missionJsonString);

      final String talkJsonString = await rootBundle.loadString(
        'assets/data/middle/middle_conversation.json',
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


  void _submitAnswer(MiddleMissionCoordinator coordinator) {
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
            _showCorrectAnswerDialog(coordinator);
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
        // 모든 문제 완료 - 메인 화면으로 이동
        Navigator.pop(context);
      }
    });
  }

  void _showCorrectAnswerDialog(MiddleMissionCoordinator coordinator) async {
    try {
      final int currentQuestionId = currentQuestionIndex + 1;
      final CorrectTalkItem correctTalk = talkList.firstWhere(
        (talk) => talk.id == currentQuestionId,
      );

      // 정답 후 대화 표시 → Coordinator로 대화 단계 이동
      coordinator.toConversation(currentQuestionId);
    } catch (e) {
      // 대화가 없는 경우 바로 다음 문제로 또는 완료 처리
      if (currentQuestionIndex + 1 >= totalQuestions) {
        // 모든 문제 완료 - 메인화면으로
        Navigator.of(context).pop();
      } else {
        _goToNextQuestion();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MiddleMissionCoordinator()),
      ],
      child: Consumer<MiddleMissionCoordinator>(
        builder: (context, coordinator, child) {
          // Coordinator와 동기화 설정 (한 번만)
          coordinator.setQuestionIndexCallback(_syncWithCoordinator);
          
          return WillPopScope(
            onWillPop: () async {
              return !coordinator.handleBack();
            },
            child: _buildCurrentStep(context, coordinator),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, MiddleMissionCoordinator coordinator) {
    // 현재 단계에 따라 화면 결정
    if (coordinator.isInConversation) {
      return ConversationOverlay(
        stage: coordinator.current.stage,
        isFinalConversation: false,
        onComplete: () {
          // 대화 종료 후 다음 문제 이동 또는 완료 처리
          final int nextStage = coordinator.current.stage + 1;
          if (nextStage <= totalQuestions) {
            coordinator.toQuestion(nextStage);
          } else {
            // 모든 문제 완료 - 메인 화면으로 이동
            Navigator.of(context).pop();
          }
        },
        onCloseByBack: () {
          // 대화에서 뒤로가기할 때는 코디네이터에서만 히스토리를 관리
          coordinator.handleBack();
        },
      );
    }

    // 기본: 질문 화면 (question 단계)
    return _buildQuestionScreen(context, coordinator);
  }

  Widget _buildQuestionScreen(BuildContext context, MiddleMissionCoordinator coordinator) {
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
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              mission.back_image.isNotEmpty
                  ? mission.back_image
                  : ImageAssets.background.path,
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
                        fontFamily: "SBAggroM",
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
                        fontFamily: "SBAggroM",
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
                          children: [
                            // 스크롤 가능한 상단 영역
                            Expanded(
                              child: SingleChildScrollView(
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
                                            fontFamily: "SBAggroM",
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
                                    // 이미지가 없을 때 간격 줄이기, 있을 때는 기본 간격
                                    SizedBox(height: mission.questionImage.isEmpty ? 4 : 8),
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
                                    // 이미지 영역 (이미지가 있을때만) - 가운데 정렬 및 유동적 높이
                                    if (mission.questionImage.isNotEmpty)
                                      SizedBox(
                                        height: 200, // 고정 높이로 설정하여 비율 유지
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.asset(
                                              mission.questionImage,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    
                                    // 옵션 영역 (옵션이 있을때만)
                                    if (mission.options.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFFFFF),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFFE0E0E0),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: mission.options.map((option) => 
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                              child: Text(
                                                option,
                                                style: TextStyle(
                                                  fontFeatures: [FontFeature.fractions()],
                                                  fontSize: MediaQuery.of(context).size.width * (16 / 360),
                                                  color: Colors.black87,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            // 하단 고정 영역 (제출 버튼/텍스트필드)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                children: [
                                  // QR 문제일 때 QR 스캔 버튼 표시
                                  if (mission.isqr) ...[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 60,
                                      child: ElevatedButton(
                                        onPressed: () => _submitAnswer(coordinator),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: mainColor,
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.qr_code_scanner,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'QR코드 스캔',
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * (16 / 360),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    // 일반 문제일 때 텍스트필드 표시
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
                                              onPressed: () => _submitAnswer(coordinator),
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
                                                '제출',
                                                style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * (12 / 360),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                      fontFamily: "SBAggroM",
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
                                      fontFamily: "SBAggroM",
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
      ),
    );
  }
}

// 중학교 대화 시퀀스를 관리하는 전용 위젯
class _MiddleConversationView extends StatefulWidget {
  final IntroViewModel viewModel;
  final VoidCallback onComplete;

  const _MiddleConversationView({
    required this.viewModel,
    required this.onComplete,
  });

  @override
  State<_MiddleConversationView> createState() => _MiddleConversationViewState();
}

class _MiddleConversationViewState extends State<_MiddleConversationView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<IntroViewModel>(
        builder: (context, vm, child) {
          final talk = vm.currentTalk;

          return CommonIntroView(
            appBarTitle: '수학자의 비밀 노트를 찾아라!',
            backgroundAssetPath: talk.backImg,
            characterImageAssetPath: talk.speakerImg,
            speakerName: '푸리',
            talkText: talk.talk,
            buttonText: '확인',
            grade: StudentGrade.middle,
            onNext: () {
              if (vm.canGoNext()) {
                vm.goToNextTalk();
              } else {
                widget.onComplete();
              }
            },
            onBack: () {
              if (vm.canGoPrevious()) {
                vm.goToPreviousTalk();
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        },
      ),
    );
  }
}
