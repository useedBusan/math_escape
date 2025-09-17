import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/utils/model/hint_model.dart';
import '../../../core/utils/view/hint_popup.dart';
import '../../../constants/enum/grade_enums.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/view/answer_popup.dart';
import '../../../core/utils/view/qr_scan_screen.dart';
import '../../../Feature/elementary_high/Model/elementary_high_correct_talk.dart';


// MissionItem class as provided in the original code
class MissionItem {
  final int id;
  final String title;
  final String question;
  final List<String> answer;
  final String hint1;
  final String hint2;

  MissionItem({
    required this.id,
    required this.title,
    required this.question,
    required this.answer,
    required this.hint1,
    required this.hint2,
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
    );
  }
}

// TalkScreen 위젯
class TalkScreen extends StatelessWidget {
  final CorrectTalkItem talk;
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
                const Center(
                  child: Text(
                    '미션! 수사모의 수학 유산을 찾아서',
                    style: TextStyle(
                      color: Color(0xffD95276),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xffD95276),
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
                  colors: [Color(0x99D95276), Color(0x99FFFFFF)],
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
                        height: MediaQuery.of(context).size.height * 0.28,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xff952B47),
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
                            color: const Color(0xffB73D5D),
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
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.93,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD95276),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onNext,
                      child: Text(
                        talk.answer,
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.width * (16 / 360),
                          fontWeight: FontWeight.bold,
                        ),
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

class ElementaryHighMissionScreen extends StatefulWidget {
  const ElementaryHighMissionScreen({super.key});

  @override
  State<ElementaryHighMissionScreen> createState() =>
      _ElementaryHighMissionScreenState();
}

class _ElementaryHighMissionScreenState
    extends State<ElementaryHighMissionScreen> {
  List<MissionItem> missionList = [];
  List<CorrectTalkItem> talkList = [];
  bool isLoading = true;
  final TextEditingController _answerController = TextEditingController();
  int currentQuestionIndex = 0;
  final int totalQuestions = 10;
  int hintCounter = 0; // 힌트 버튼 클릭 횟수를 추적하는 변수

  @override
  void initState() {
    super.initState();
    loadMissionData();
  }

  Future<void> loadMissionData() async {
    try {
      // 미션 화면 데이터 로드
      final String missionJsonString = await rootBundle.loadString(
        'assets/data/elementary_high/elementary_high_question.json',
      );
      final List<dynamic> missionJsonList = json.decode(missionJsonString);

      // 정답 화면 대화 데이터 로드
      final String talkJsonString = await rootBundle.loadString(
        'assets/data/elementary_high/elementary_high_correct_talks.json',
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

    int newHintCounter = (hintCounter % 2) + 1;
    setState(() {
      hintCounter = newHintCounter;
    });

    // 힌트 문구 결정
    final String upText = '푸리 힌트 $newHintCounter / 2';
    final String downText = newHintCounter == 1
        ? currentMission.hint1
        : currentMission.hint2;

    //TODO: 공용 힌트모델 사용
  }


  void _handleSubmit() {
    final int questionNumber = currentQuestionIndex + 1;

    // QR 스캔이 필요한 문제들 (2, 3, 4, 8번)
    final qrScanQuestions = [2, 3, 4, 8];

    if (qrScanQuestions.contains(questionNumber)) {
      _openQRScanner();
    } else {
      _submitTextAnswer();
    }
  }

  void _openQRScanner() async {
    // 카메라 권한 요청
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // QR 스캔 화면으로 이동
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QRScanScreen()),
      );

      if (result != null && result is String) {
        // QR 스캔 결과 처리
        _handleQRScanResult(result);
      }
    } else {
      // 권한 거부 시 안내 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카메라 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _submitTextAnswer() {
    final MissionItem currentMission = missionList[currentQuestionIndex];
    final String userAnswer = _answerController.text.trim();

    final bool correct = currentMission.answer.contains(userAnswer);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnswerPopup(
        isCorrect: correct,
        grade: StudentGrade.high,
        onNext: () {
          Navigator.pop(context); // 정답 팝업 닫기
          if (correct) {
            // 정답일 때만 대화 화면으로 이동
            _showCorrectAnswerDialog();
          }
          // 오답일 때는 아무것도 하지 않음 (현재 문제 유지)
        },
      ),
    );
  }

  void _handleQRScanResult(String qrResult) {
    final MissionItem currentMission = missionList[currentQuestionIndex];

    // QR 스캔 결과를 정답과 비교
    final bool correct = currentMission.answer.contains(qrResult.trim());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AnswerPopup(
        isCorrect: correct,
        grade: StudentGrade.elementaryHigh,
        onNext: () {
          Navigator.pop(context); // 정답 팝업 닫기
          if (correct) {
            // 정답일 때만 대화 화면으로 이동
            _showCorrectAnswerDialog();
          }
          // 오답일 때는 아무것도 하지 않음 (현재 문제 유지)
        },
      ),
    );
  }

  void _goToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < missionList.length - 1) {
        currentQuestionIndex++;
        _answerController.clear();
        hintCounter = 0;
      } else {
        Navigator.pop(context); // 마지막 문제면 화면 종료
      }
    });
  }

  Widget _buildSubmitButtonContent(BuildContext context) {
    final int questionNumber = currentQuestionIndex + 1;
    final qrScanQuestions = [2, 3, 4, 8];

    if (qrScanQuestions.contains(questionNumber)) {
      // QR 스캔 버튼
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            'QR 스캔',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * (16 / 360),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      // 텍스트 입력 버튼
      return Text(
        '정답제출',
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * (16 / 360),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildAnswerInput(BuildContext context) {
    final int questionNumber = currentQuestionIndex + 1;
    final qrScanQuestions = [2, 3, 4, 8];
    final Color mainColor = const Color(0xffD95276);

    if (qrScanQuestions.contains(questionNumber)) {
      // QR 스캔 문제는 입력 필드 숨김
      return const SizedBox.shrink();
    } else {
      // 텍스트 입력 문제는 입력 필드 표시
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: const Color(0xffdcdcdc)),
        ),
        child: TextField(
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * (15 / 360),
          ),
          controller: _answerController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: '정답을 입력해 주세요.',
            hintStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * (14 / 360),
              color: Color(0xffaaaaaa),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: const BorderSide(color: Color(0xffaaaaaa)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide: BorderSide(color: mainColor, width: 2.0),
            ),
          ),
        ),
      );
    }
  }

  void _showCorrectAnswerDialog() {
    try {
      final int currentQuestionId = currentQuestionIndex + 1;

      int firstTalkId;

      if (currentQuestionId <= 4) {
        // 문제 1~4 → 대화 1~4
        firstTalkId = currentQuestionId;
      } else if (currentQuestionId == 5) {
        // 문제 5 → 대화 5 → next_id=6
        firstTalkId = 5;
      } else {
        // 문제 6~10 → 대화 (문제번호 + 1)
        firstTalkId = currentQuestionId + 1;
      }

      final CorrectTalkItem firstTalk = talkList.firstWhere(
        (talk) => talk.id == firstTalkId,
      );

      void showTalk(CorrectTalkItem talk) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TalkScreen(
              talk: talk,
              onNext: () {
                Navigator.pop(context);

                if (talk.nextId != null) {
                  final nextTalk = talkList.firstWhere(
                    (t) => t.id == talk.nextId,
                  );
                  showTalk(nextTalk);
                } else {
                  _goToNextQuestion();
                }
              },
            ),
          ),
        );
      }

      showTalk(firstTalk);
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
    final Color mainColor = const Color(0xffD95276);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // 키보드 올라와도 레이아웃 안 밀림
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffD95276)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '미션! 수사모의 수학 보물을 찾아서',
          style: TextStyle(
            color: Color(0xffD95276),
            fontSize: MediaQuery.of(context).size.width * (16 / 360),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // 본문
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/elementary_banner.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: LinearProgressIndicator(
                              value:
                                  (currentQuestionIndex + 1) / totalQuestions,
                              backgroundColor: const Color(0xffebebeb),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                mainColor,
                              ),
                              minHeight: 10,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '문제 ${currentQuestionIndex + 1} / $totalQuestions',
                                style: TextStyle(
                                  fontFamily: "SBAggro",
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                      (18 / 360),
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff202020),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mission.question,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  height: 1.4,
                                  fontSize:
                                      MediaQuery.of(context).size.width *
                                      (16 / 360),
                                  color: Color(0xff333333),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildAnswerInput(context),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 하단 버튼 고정
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffedfa),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: mainColor, width: 2),
                      ),
                    ),
                    onPressed: _showHintDialog,
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 버튼 크기를 내용에 맞춤
                      children: [
                        Icon(
                          Symbols.tooltip_2,
                          color: mainColor,
                          size: 24,
                        ), // 아이콘
                        SizedBox(width: 6), // 간격
                        Text(
                          '힌트',
                          style: TextStyle(
                            color: mainColor,
                            fontSize:
                                MediaQuery.of(context).size.width * (16 / 360),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _handleSubmit,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [_buildSubmitButtonContent(context)],
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