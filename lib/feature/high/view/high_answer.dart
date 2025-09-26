import 'package:flutter/material.dart';
import 'dart:async';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../Feature/high/view/answer_widgets.dart';
import '../../../Feature/high/view/high_mission.dart';
import 'widgets/hourglass_timer_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class HighAnswer extends StatefulWidget {
  final MissionAnswer answer;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;
  final int currentIndex;

  const HighAnswer({
    super.key,
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
  });

  @override
  State<HighAnswer> createState() => _HighAnswerState();
}

class _HighAnswerState extends State<HighAnswer> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.gameStartTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.gameStartTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get thinkingTime {
    final minutes = _elapsed.inMinutes;
    final seconds = _elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get bodyTime {
    final totalSeconds = _elapsed.inSeconds;
    final c = totalSeconds ~/ 60;
    final d = (totalSeconds % 60) ~/ 5;
    return '$c년, $d개월';
  }

  List<InlineSpan> parseExplanation(String explanation, double fontSize) {
    final regex = RegExp(r'\$(.+?)\$');
    final matches = regex.allMatches(explanation);
    List<InlineSpan> spans = [];
    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: explanation
                .substring(lastEnd, match.start)
                .replaceAll('\\\\', '\\'),
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.textQuaternary,
            ),
          ),
        );
      }
      final latex = match.group(1)!.replaceAll('\\\\', '\\');
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Math.tex(
            latex,
            textStyle: TextStyle(
              fontSize: fontSize + 2,
              color: AppColors.textQuaternary,
            ),
          ),
        ),
      );
      lastEnd = match.end;
    }
    if (lastEnd < explanation.length) {
      spans.add(
        TextSpan(
          text: explanation.substring(lastEnd).replaceAll('\\\\', '\\'),
          style: TextStyle(fontSize: fontSize, color: AppColors.textQuaternary),
        ),
      );
    }
    return spans;
  }

  void handleNextButton() {
    final title = widget.answer.title;
    if (title == '역설, 혹은 모호함_A' || title == '진리_A') {
      final idx = widget.questionList.indexWhere((qq) => qq.id == 1);
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
    } else if (title == '역설, 혹은 모호함_1' || title == '진리_1') {
      final idx = widget.questionList.indexWhere((qq) => qq.id == 3);
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
    } else if (title == '역설, 혹은 모호함_3' || title == '진리_3') {
      // 문제 3번의 진리 페이지에서 다음 문제로 버튼을 누르면 문제 4번으로 이동
      final idx = widget.questionList.indexWhere((qq) => qq.id == 6);
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
      if (widget.currentIndex + 1 < widget.questionList.length) {
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSize = screenWidth * AppDimensions.fontSizeLarge;

    // 문제 3번의 진리 페이지인지 확인
    final isQuestion3Truth =
        widget.answer.title == '역설, 혹은 모호함_3' || widget.answer.title == '진리_3';

    if (isQuestion3Truth) {
      // 문제 3번의 진리 페이지 - 새로운 디자인
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundLightGray,
        appBar: AppBar(
          backgroundColor: AppColors.primaryWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '역설, 혹은 모호함',
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontSize: screenWidth * AppDimensions.fontSizeMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // 상단 설명 텍스트 (미션창 상단과 동일)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              margin: const EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.backgroundLightBlue,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Row(
                children: [
                  // 퓨리 이미지 (왼쪽)
                  Container(
                    width: AppDimensions.imageSizeSmall,
                    height: AppDimensions.imageSizeSmall,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/high/highFuri.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMedium),
                  // 텍스트 (오른쪽)
                  Expanded(
                    child: Text(
                      '인류의 처음 정수의 정수는 한 개인의\n처음 정수를 만들기 위해 가장 기본이 되는 것,\n곧, 정수!',
                      style: TextStyle(
                        fontFamily: "SBAggroM",
                        fontSize: screenWidth * AppDimensions.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                        height: AppDimensions.lineHeightMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 가운데 콘텐츠 영역
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * AppDimensions.spacingMedium,
                  vertical: screenWidth * AppDimensions.spacingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 진리 3 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowBlack,
                            blurRadius: AppDimensions.shadowBlurRadius,
                            offset: const Offset(
                              0,
                              AppDimensions.shadowOffsetY,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.answer.title,
                            style: TextStyle(
                              fontSize:
                                  screenWidth * AppDimensions.fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          Text(
                            widget.answer.explanation,
                            style: TextStyle(
                              fontSize:
                                  screenWidth * AppDimensions.fontSizeLarge,
                              color: AppColors.textQuaternary,
                              height: AppDimensions.lineHeightExtraLarge,
                            ),
                          ),
                          // 이미지 표시
                          const SizedBox(height: AppDimensions.paddingMedium),
                          Center(
                            child: Image.asset(
                              'assets/images/high/high3.png',
                              width: screenWidth * 0.6,
                              height: screenWidth * 0.4,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * AppDimensions.spacingMedium,
                    ),

                    // 문구의 단서 3 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                      decoration: BoxDecoration(
                        color: AppColors.cardLightGray,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.answer.clueTitle,
                            style: TextStyle(
                              fontSize:
                                  screenWidth * AppDimensions.fontSizeTitle,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingMedium),
                          Text(
                            widget.answer.clue,
                            style: TextStyle(
                              fontSize:
                                  screenWidth * AppDimensions.fontSizeLarge,
                              fontWeight: FontWeight.normal,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * AppDimensions.spacingExtraLarge,
                    ),

                    // 다음 문제로 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: handleNextButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.primaryWhite,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingExtraLarge,
                            vertical: AppDimensions.paddingMedium,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSmall,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('다음 문제', style: TextStyle(fontSize: fontSize)),
                            const SizedBox(width: AppDimensions.paddingSmall),
                            const Icon(
                              Icons.arrow_forward,
                              size: AppDimensions.iconSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * AppDimensions.spacingMedium,
                    ),
                  ],
                ),
              ),
            ),

            // 하단 모래시계 타이머
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: HourglassTimerBar(
                mainColor: AppColors.primaryBlue,
                think: thinkingTime,
                body: bodyTime,
                progress: 0.0,
              ),
            ),
          ],
        ),
      );
    } else {
      // 문제 1, 2번의 진리 페이지 - 기존 디자인 복원
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primaryWhite,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * AppDimensions.spacingMedium,
            vertical: screenWidth * AppDimensions.spacingMedium,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DescriptionLevelBox(
                description: widget.answer.description,
                level: widget.answer.level,
                fontSize: screenWidth * 0.035,
              ),
              SizedBox(height: screenHeight * AppDimensions.spacingMedium),
              Text(
                widget.answer.title,
                style: TextStyle(
                  fontSize: screenWidth * AppDimensions.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: screenHeight * AppDimensions.spacingSmall),
              ExplanationBox(
                explanationSpans: parseExplanation(
                  widget.answer.explanation,
                  screenWidth * 0.05,
                ),
                answerImage: widget.answer.answerImage,
                fontSize: screenWidth * 0.05,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SizedBox(height: screenHeight * AppDimensions.spacingLarge),
              ClueBox(
                clueTitle: widget.answer.clueTitle,
                clue: widget.answer.clue,
                fontSize: screenWidth * AppDimensions.fontSizeLarge,
              ),
              SizedBox(height: screenHeight * AppDimensions.spacingSmall),
              const SizedBox(height: AppDimensions.paddingMedium),
              Center(
                child: ElevatedButton(
                  onPressed: handleNextButton,
                  child: Text(
                    widget.answer.title == '역설, 혹은 모호함_A' ||
                            widget.answer.title == '진리_A'
                        ? '돌아가기'
                        : (widget.answer.title == '역설, 혹은 모호함_1' ||
                              widget.answer.title == '진리_1')
                        ? '다음 문제로'
                        : (widget.currentIndex + 1 < widget.questionList.length
                              ? '다음 문제로'
                              : '마지막 문제'),
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingLarge),
              Center(
                child: HourglassTimerBar(
                  mainColor: AppColors.primaryBlue,
                  think: thinkingTime,
                  body: bodyTime,
                  progress: 0.0, // 답안 화면에서는 진행률 표시 안함
                ),
              ),
              SizedBox(height: AppDimensions.paddingLarge),
            ],
          ),
        ),
      );
    }
  }
}
