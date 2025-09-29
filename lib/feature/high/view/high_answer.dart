import 'package:flutter/material.dart';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../App/theme/app_colors.dart';
import '../../../Feature/high/view/high_mission.dart';
import '../view_model/high_answer_view_model.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/view/home_alert.dart';
import 'base_high_view.dart';
import '../view_model/base_high_view_model.dart';
import 'high_clear_view.dart';

class HighAnswer extends StatelessWidget {
  final MissionAnswer answer;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final bool isFromHint;

  const HighAnswer({
    super.key,
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
    this.isFromHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: HighAnswerViewModel.instance,
        ),
        ChangeNotifierProvider(
          create: (_) => BaseHighViewModel(),
        ),
      ],
      child: _HighAnswerContent(
        answer: answer,
        gameStartTime: gameStartTime,
        questionList: questionList,
        currentIndex: currentIndex,
        isFromHint: isFromHint,
      ),
    );
  }
}

class _HighAnswerContent extends StatefulWidget {
  final MissionAnswer answer;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final bool isFromHint;

  const _HighAnswerContent({
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
    required this.isFromHint,
  });

  @override
  State<_HighAnswerContent> createState() => _HighAnswerContentState();
}

class _HighAnswerContentState extends State<_HighAnswerContent> {
  @override
  void initState() {
    super.initState();
    // ViewModel 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HighAnswerViewModel.instance.initializeAnswer(
        answer: widget.answer,
        gameStartTime: widget.gameStartTime,
        isFromHint: widget.isFromHint,
      );
    });
  }

  List<InlineSpan> parseExplanation(String explanation, double fontSize) {
    final regex = RegExp(r'\$(.+?)\$');
    final matches = regex.allMatches(explanation);
    List<InlineSpan> spans = [];
    int lastEnd = 0;

    for (final match in matches) {
      if (lastEnd < match.start) {
        spans.add(
          TextSpan(
            text: explanation.substring(lastEnd, match.start).replaceAll('\\\\', '\\'),
            style: TextStyle(fontSize: fontSize, color: Colors.black87),
          ),
        );
      }
      spans.add(
        WidgetSpan(
          child: Math.tex(
            match.group(1)!,
            textStyle: TextStyle(fontSize: fontSize),
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < explanation.length) {
      spans.add(
        TextSpan(
          text: explanation.substring(lastEnd).replaceAll('\\\\', '\\'),
          style: TextStyle(fontSize: fontSize, color: Colors.black87),
        ),
      );
    }
    return spans;
  }

  void handleNextButton() {
    HighAnswerViewModel.instance.handleNextButton(
      currentIndex: widget.currentIndex,
      questionListLength: widget.questionList.length,
      onNavigateToNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: widget.currentIndex + 1,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      },
      onNavigateBack: () {
        Navigator.pop(context); // HighAnswer pop
        Navigator.pop(context); // HighHintView pop
      },
      onComplete: () {
        // 마지막 문제인 경우 - HighClearView로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighClearView(
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HighAnswerViewModel, BaseHighViewModel>(
      builder: (context, vm, baseVm, child) {
        return WillPopScope(
          onWillPop: () async {
            final result = await HomeAlert.show(context);
            if (result == true) {
              // 타이머 초기화
              HighAnswerViewModel.instance.endAnswer();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            return false; // 기본 뒤로가기 동작 방지
          },
          child: BaseHighView(
            title: '역설, 혹은 모호함',
            background: Container(color: Color(0xFFF5F5F5)),
            paneBuilder: (context, pane) => _buildAnswerContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildAnswerContent(HighAnswerViewModel vm) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * 17/360;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              // 퓨리 이미지 공간 (왼쪽)
              Container(
                width: 60,
                height: 60,
                child: Center(
                  child: Image.asset(
                    "assets/images/high/highFuri.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 텍스트 (오른쪽)
              Expanded(
                child: Text(
                  '인류의 처음 정수의 정수는 한 개인의 처음 정수를 만들기 위해 가장 기본이 되는 것. 곧, 정수!',
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: screenWidth * (13 / 360),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF1A1A1A),
                    // height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          SizedBox(height: screenHeight * 0.025),

          // 본문 (설명 + 이미지)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 진리 A 타이틀
                Text(
                  vm.currentAnswer?.title ?? widget.answer.title,
                  style: TextStyle(
                    fontFamily: "SBAggroM",
                    fontSize: screenWidth * 18/360,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                RichText(
                  text: TextSpan(
                    children: parseExplanation(
                      vm.currentAnswer?.explanation ?? widget.answer.explanation,
                      screenWidth * 14/360,
                    ),
                  ),
                ),
                if ((vm.currentAnswer?.answerImage ?? widget.answer.answerImage) != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      vm.currentAnswer?.answerImage ?? widget.answer.answerImage!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // 문구의 단서 박스
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFDCDCDC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.currentAnswer?.clueTitle ?? widget.answer.clueTitle,
                  style: TextStyle(
                    fontFamily: "SBAggroM",
                    fontSize: screenWidth * 18/360,
                    color: AppColors.head
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vm.currentAnswer?.clue ?? widget.answer.clue,
                  style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: screenWidth * 14/360,
                    color: AppColors.body
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // 다음 문제 버튼
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomBlue.s500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: handleNextButton,
                child: Text(
                  vm.isFromHint
                      ? '돌아가기'
                      : (widget.currentIndex + 1 < widget.questionList.length
                      ? '다음 문제'
                      : '마지막 문제'),
                  style: TextStyle(
                    fontSize: screenWidth * 16/360,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // 모래시계 원까지 올라가도록 여백 추가
          SizedBox(height: screenHeight * 0.15),
        ],
      ),
    );
  }
}