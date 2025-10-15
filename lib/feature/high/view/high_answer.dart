import 'package:flutter/material.dart';
import 'package:math_escape/core/extensions/string_extension.dart';
import 'package:math_escape/feature/high/model/high_mission_answer.dart';
import 'package:math_escape/feature/high/model/high_mission_question.dart';
import '../../../App/theme/app_colors.dart';
import '../../../feature/high/view/high_mission.dart';
import '../view_model/high_answer_view_model.dart';
import '../view_model/high_mission_view_model.dart';
import '../view_model/high_hint_view_model.dart';
import 'package:provider/provider.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/views/integer_phase_banner.dart';
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
    // view_model 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      HighAnswerViewModel.instance.initializeAnswer(
        answer: widget.answer,
        gameStartTime: widget.gameStartTime,
        isFromHint: widget.isFromHint,
      );
    });
  }


  void handleNextButton() {
    HighAnswerViewModel.instance.handleNextButton(
      currentIndex: widget.currentIndex,
      questionListLength: widget.questionList.length,
      onNavigateToNext: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'HighMission'),
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: widget.currentIndex + 1,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      },
      onNavigateBack: () {
        // HighMission으로 돌아가기
        Navigator.popUntil(context, (route) => route.settings.name == 'HighMission');
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
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              final alertResult = await HomeAlert.show(context);
              if (alertResult == true && context.mounted) {
                // 모든 상태 해제
                HighMissionViewModel.instance.disposeAll();
                HighHintViewModel.instance.disposeAll();
                HighAnswerViewModel.instance.disposeAll();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          IntegerPhaseBanner(
            questionNumber: widget.currentIndex + 1,
            furiImagePath: "assets/images/high/highFuri.png",
            fontSize: 14,
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
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.currentAnswer?.title ?? widget.answer.title,
                  style: TextStyle(
                    fontFamily: "SBAggroM",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                //진리 박스
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontFamily: "Pretendard",
                        height: 1.5,
                        color: AppColors.body
                    ),
                    children: (vm.currentAnswer?.explanation ?? widget.answer.explanation).toStyledSpans(fontSize: 15),
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "SBAggroM",
                      fontSize: 18,
                      color: AppColors.head
                    ),
                    children: (vm.currentAnswer?.clueTitle ?? widget.answer.clueTitle).toStyledSpans(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      height: 1.5,
                      color: AppColors.body
                    ),
                    children: (vm.currentAnswer?.clue ?? widget.answer.clue).toStyledSpans(fontSize: 15),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          // 하단바 높이만큼 여백 추가 (모래시계 원 높이)
          SizedBox(height: screenHeight * 0.13),
        ],
        ),
      ),
    );
  }
}