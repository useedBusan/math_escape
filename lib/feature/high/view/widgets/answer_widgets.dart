import 'package:flutter/material.dart';
import '../../../Feature/high/high_answer_constants.dart';

class DescriptionLevelBox extends StatelessWidget {
  final String description;
  final String level;
  final double fontSize;
  const DescriptionLevelBox({required this.description, required this.level, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(fontSize * 0.85),
            decoration: BoxDecoration(
              color: HighAnswerConstants.descriptionBoxColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              description,
              style: TextStyle(fontSize: fontSize, color: Colors.black87, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: fontSize * 0.85, vertical: fontSize * 0.6),
          decoration: BoxDecoration(
            color: HighAnswerConstants.levelBoxColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            level,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class ExplanationBox extends StatelessWidget {
  final List<InlineSpan> explanationSpans;
  final String? answerImage;
  final double fontSize;
  final double screenWidth;
  final double screenHeight;
  const ExplanationBox({required this.explanationSpans, this.answerImage, required this.fontSize, required this.screenWidth, required this.screenHeight, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: HighAnswerConstants.explanationBoxColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (answerImage != null && answerImage!.isNotEmpty)
            Column(
              children: [
                Image.asset(
                  answerImage!,
                  width: screenWidth * 0.7,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.015),
              ],
            ),
          RichText(
            text: TextSpan(children: explanationSpans),
          ),
        ],
      ),
    );
  }
}

class ClueBox extends StatelessWidget {
  final String clueTitle;
  final String clue;
  final double fontSize;
  const ClueBox({required this.clueTitle, required this.clue, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clueTitle,
          style: TextStyle(
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: fontSize * 0.2),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(fontSize),
          decoration: BoxDecoration(
            color: HighAnswerConstants.clueBoxColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: clue,
                  style: TextStyle(
                    backgroundColor: HighAnswerConstants.clueHighlightColor,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize * 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimerInfoBox extends StatelessWidget {
  final String thinkingTime;
  final String bodyTime;
  final double fontSize;
  const TimerInfoBox({required this.thinkingTime, required this.bodyTime, required this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: fontSize * 1.2, vertical: fontSize * 0.6),
          margin: EdgeInsets.only(bottom: fontSize * 0.2),
          decoration: BoxDecoration(
            color: HighAnswerConstants.timerBoxColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: HighAnswerConstants.timerBoxShadow,
                blurRadius: 2,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Text(
            '생각의 시간 $thinkingTime',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: fontSize * 1.2, vertical: fontSize * 0.6),
          decoration: BoxDecoration(
            color: HighAnswerConstants.timerBoxColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: HighAnswerConstants.timerBoxShadow,
                blurRadius: 2,
                offset: Offset(1, 2),
              ),
            ],
          ),
          child: Text(
            '몸의 시간 $bodyTime',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}