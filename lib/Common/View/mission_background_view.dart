import 'package:flutter/material.dart';
import 'package:math_escape/widgets/elementary_high_answer_popup.dart';
import '../Enums/grade_enums.dart';

class MissionBackgroundView extends StatelessWidget {
  // 외부에서 주입받는 parameters
  const MissionBackgroundView({
    super.key,
    required this.grade,
    required this.title,
    required this.missionBuilder,
    required this.hintDialogueBuilder,
    required this.onSubmitAnswer,

    this.onCorrect,
    this.onWrong,
    this.onBack,
  });

  // Properties
  final StudentGrade grade;
  final String title;

  final Widget Function(BuildContext context) missionBuilder;
  final Widget Function(BuildContext context) hintDialogueBuilder;
  final Future<bool> Function(BuildContext context) onSubmitAnswer;

  final VoidCallback? onCorrect;
  final VoidCallback? onWrong;
  final VoidCallback? onBack;

  // View
  @override
  Widget build(BuildContext context) {
    final mainColor = grade.mainColor;
    final bannerImgPath = grade.bannerImg;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mainColor, size: 28),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          if (bannerImgPath != null)
            SizedBox(
              width: double.infinity,
              child: Image.asset(bannerImgPath, fit: BoxFit.cover),
            ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: missionBuilder(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: mainColor),
                      foregroundColor: mainColor,
                      backgroundColor: Color(0xffFFEDFA),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: hintDialogueBuilder,
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/hint.png",
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 2),
                        Text('힌트'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                    ),
                    onPressed: () async {
                      final ok = await onSubmitAnswer(context);
                      if (!context.mounted) return;

                      showDialog(
                        context: context,
                        builder: (context) => AnswerPopup(
                          isCorrect: ok,
                          onNext: () {
                            Navigator.of(context).pop();
                            if (ok) {
                              onCorrect?.call();
                            } else {
                              onWrong?.call();
                            }
                          },
                        ),
                      );
                    },
                    child: const Text('정답 제출'),
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