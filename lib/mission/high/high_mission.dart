//고등학생 미션 화면 구현

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/models/high/high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/models/high/high_mission_answer.dart';
import 'package:math_escape/mission/high/high_answer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:math_escape/screens/qr_scan_screen.dart';
import 'package:math_escape/widgets/answer_popup.dart';
import 'package:math_escape/mission/high/widgets.dart';
import 'package:math_escape/mission/high/high_mission_widgets.dart';

class HighMission extends StatefulWidget {
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final DateTime gameStartTime;

  const HighMission({
    super.key,
    required this.questionList,
    required this.currentIndex,
    required this.gameStartTime,
  });

  @override
  State<HighMission> createState() => _HighMissionState();
}

class _HighMissionState extends State<HighMission> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  Duration _elapsed = Duration.zero;
  Duration _totalTime = const Duration(minutes: 90);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.gameStartTime);
        if (_elapsed >= _totalTime) {
          _elapsed = _totalTime;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  String get thinkingTime {
    final minutes = _elapsed.inMinutes;
    final seconds = _elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    return _elapsed.inSeconds / _totalTime.inSeconds;
  }

  Color get _progressColor {
    return _progress >= 4.0 / 3.0
        ? const Color(0xFFD95276)
        : const Color(0xFF883BB);
  }

  String get bodyTime {
    final totalSeconds = _elapsed.inSeconds;
    final c = totalSeconds ~/ 60;
    final d = (totalSeconds % 60) ~/ 5;
    return '$c년, $d개월';
  }

  Future<MissionAnswer> loadAnswerById(int id) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_answer.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => MissionAnswer.fromJson(e))
        .firstWhere((a) => a.id == id);
  }

  Future<List<MissionQuestion>> loadQuestionList() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/high/high_level_question.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => MissionQuestion.fromJson(e)).toList();
  }

  Future<void> showAnswerPopup(
    BuildContext context, {
    required bool isCorrect,
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(child: AnswerPopup(isCorrect: isCorrect));
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final q = widget.questionList[widget.currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Color(0xFF0066FF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '역설, 혹은 모호함',
          style: TextStyle(
            color: const Color(0xFF0066FF),
            fontSize: screenWidth * (16 / 360),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 첫 번째 카드 - 설명 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 왼쪽 원형 아바타
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 오른쪽 설명 텍스트
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.description,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: screenWidth * (14 / 360),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '고급',
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: screenWidth * (12 / 360),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0066FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 두 번째 카드 - 문제 영역 (3단 중첩)
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // 첫 번째 레이어 (어두운 배경)
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF324486),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF324486),
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
                  // 두 번째 레이어 (중간 배경)
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6577B9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF324486),
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
                  // 세 번째 레이어 (흰색 콘텐츠)
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.height * 0.5,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF324486),
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
                        // 제목과 힌트 버튼
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '역설, 혹은 모호함 1',
                              style: TextStyle(
                                fontFamily: "Pretendard",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.help_outline,
                                color: Color(0xFF0066FF),
                                size: 24,
                              ),
                              onPressed: () async {
                                if (q.title == '역설, 혹은 모호함_1') {
                                  final idx = widget.questionList.indexWhere(
                                    (qq) => qq.id == 2,
                                  );
                                  if (idx != -1) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HighMission(
                                          questionList: widget.questionList,
                                          currentIndex: idx,
                                          gameStartTime: widget.gameStartTime,
                                        ),
                                      ),
                                    );
                                  }
                                } else if (q.title == '역설, 혹은 모호함_3') {
                                  final idx = widget.questionList.indexWhere(
                                    (qq) => qq.id == 5,
                                  );
                                  if (idx != -1) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HighMission(
                                          questionList: widget.questionList,
                                          currentIndex: idx,
                                          gameStartTime: widget.gameStartTime,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('힌트'),
                                        content: Text(q.hint),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('확인'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 문제 설명
                        Text(
                          q.question,
                          style: TextStyle(
                            fontFamily: "Pretendard",
                            fontSize: screenWidth * (16 / 360),
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        // 공간을 채우는 Expanded 위젯
                        const Expanded(child: SizedBox()),
                        // 답변 입력 영역
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: '정답을 입력해 주세요.',
                                  hintStyle: TextStyle(
                                    fontSize: screenWidth * (14 / 360),
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0066FF),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () async {
                                final input = _controller.text
                                    .trim()
                                    .toLowerCase();
                                final answers = q.answer
                                    .map((a) => a.trim().toLowerCase())
                                    .toList();
                                final isCorrect = answers.contains(input);
                                await showAnswerPopup(
                                  context,
                                  isCorrect: isCorrect,
                                );
                                if (isCorrect) {
                                  final answerData = await loadAnswerById(q.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HighAnswer(
                                        answer: answerData,
                                        gameStartTime: widget.gameStartTime,
                                        questionList: widget.questionList,
                                        currentIndex: widget.currentIndex,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0066FF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: screenWidth * (14 / 360),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // QR 코드 버튼 (특정 문제에서만)
            if (q.title == '역설, 혹은 모호함_B') ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(
                    'QR코드 촬영',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  onPressed: () async {
                    final status = await Permission.camera.request();
                    if (status.isGranted) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => QRScanScreen()),
                      );
                      if (result != null && result is String) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('QR 코드 결과: $result')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('카메라 권한이 필요합니다.')),
                      );
                    }
                  },
                ),
              ),
            ],
            const SizedBox(height: 24),
            // 하단 타이머 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 왼쪽: 생각의 시간
                  Text(
                    '생각의 시간 $thinkingTime',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: screenWidth * (14 / 360),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  // 가운데: 원형 진행률 타이머
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        // 배경 원
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                        ),
                        // 진행률 원
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            value: _progress.clamp(0.0, 1.0),
                            strokeWidth: 4,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _progressColor,
                            ),
                          ),
                        ),
                        // 중앙 아이콘
                        Center(
                          child: Icon(
                            Icons.timer,
                            color: const Color(0xFF0066FF),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 오른쪽: 몸의 시간
                  Text(
                    '몸의 시간 $bodyTime',
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: screenWidth * (14 / 360),
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
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
