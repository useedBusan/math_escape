import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/models/elementary_high/elementary_high_mission_question.dart';
import 'dart:async';
import 'package:math_escape/models/elementary_high/elementary_high_mission_answer.dart';
import 'package:math_escape/widgets/answer_popup.dart';

class ElementaryHighMission extends StatefulWidget {
  const ElementaryHighMission({super.key});

  @override
  State<ElementaryHighMission> createState() => _ElementaryHighMissionState();
}

class _ElementaryHighMissionState extends State<ElementaryHighMission> {
  final TextEditingController _controller = TextEditingController();
  late Timer _timer;
  Duration _elapsed = Duration.zero;
  List<ElementaryHighMissionQuestion> questionList = [];
  int currentIndex = 0;
  DateTime gameStartTime = DateTime.now();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(gameStartTime);
      });
    });
  }

  Future<void> _loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/data/elementary_high/high_elementary_question.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        questionList = jsonList.map((e) => ElementaryHighMissionQuestion.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('질문 로드 오류: $e');
      setState(() {
        isLoading = false;
      });
    }
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

  Future<ElementaryHighMissionAnswer> loadAnswerById(int id) async {
    final String jsonString = await rootBundle.loadString('lib/data/elementary_high/high_elementary_answer.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    return jsonData
        .map((e) => ElementaryHighMissionAnswer.fromJson(e))
        .firstWhere((a) => a.id == id);
  }

  Future<void> showAnswerPopup(BuildContext context, {required bool isCorrect}) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: AnswerPopup(isCorrect: isCorrect),
        );
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

  void checkAnswer() {
    if (questionList.isEmpty || currentIndex >= questionList.length) return;

    final currentQuestion = questionList[currentIndex];
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswers = currentQuestion.answer.map((e) => e.toLowerCase()).toList();

    final isCorrect = correctAnswers.contains(userAnswer);

    showAnswerPopup(context, isCorrect: isCorrect).then((_) {
      if (isCorrect) {
        if (currentIndex < questionList.length - 1) {
          setState(() {
            currentIndex++;
            _controller.clear();
          });
        } else {
          // 모든 문제 완료
          _showCompletionDialog();
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('축하합니다!'),
        content: const Text('모든 문제를 완료했습니다!\n수학의 신비한 세계를 탐험하는 동안\n많은 것을 배우셨을 거예요.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('메인으로 돌아가기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questionList.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('푸리와 매매의 수학 보물 대탐험'),
          backgroundColor: Colors.white,
          foregroundColor: Color(0xffed668a),
        ),
        body: const Center(
          child: Text('문제를 불러올 수 없습니다.'),
        ),
      );
    }

    final currentQuestion = questionList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('푸리와 매매의 수학 보물 대탐험'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimerSection(),
              const SizedBox(height: 16),
              _buildProgressSection(),
              const SizedBox(height: 24),
              _buildQuestionSection(currentQuestion),
              const SizedBox(height: 24),
              _buildAnswerSection(),
              const Spacer(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '경과 시간:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            thinkingTime,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Row(
      children: [
        Text(
          '문제 ${currentIndex + 1} / ${questionList.length}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        LinearProgressIndicator(
          value: (currentIndex + 1) / questionList.length,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      ],
    );
  }

  Widget _buildQuestionSection(ElementaryHighMissionQuestion question) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            if (question.questionImage != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    question.questionImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (question.questionImage != null) const SizedBox(height: 16),
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '힌트: ${question.hint1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.orange,
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

  Widget _buildAnswerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '답을 입력하세요:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '답을 입력하세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          onSubmitted: (_) => checkAnswer(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _controller.text.trim().isEmpty ? null : checkAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '답 확인하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 