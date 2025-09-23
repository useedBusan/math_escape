import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/answer_popup.dart';

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
    this.isqr = false, // QR 인식 여부 추가
  });

  // Properties
  final StudentGrade grade;
  final String title;
  final bool isqr; // QR 인식 여부

  final Widget Function(BuildContext context) missionBuilder;
  final Widget Function(BuildContext context) hintDialogueBuilder;
  final Future<bool> Function(BuildContext context) onSubmitAnswer;

  final VoidCallback? onCorrect;
  final VoidCallback? onWrong;
  final VoidCallback? onBack;

  // view
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
              padding: const EdgeInsets.all(0),
              child: missionBuilder(context),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/common/hintIcon.png",
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 4),
                          Text('힌트'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: mainColor),
                        foregroundColor: Colors.white,
                        backgroundColor: mainColor,
                      ),
                      onPressed: () async {
                        if (isqr) {
                          // QR 문제일 때는 바로 정답으로 처리
                          showDialog(
                            context: context,
                            builder: (context) => AnswerPopup(
                              isCorrect: true,
                              grade: grade,
                              onNext: () {
                                Navigator.of(context).pop();
                                onCorrect?.call();
                              },
                            ),
                          );
                        } else {
                          // 일반 문제일 때는 기존 로직 사용
                          final ok = await onSubmitAnswer(context);
                          if (!context.mounted) return;

                          showDialog(
                            context: context,
                            builder: (context) => AnswerPopup(
                              isCorrect: ok,
                              grade: grade,
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
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isqr) ...[
                            Icon(
                              Icons.qr_code_scanner,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                          ],
                          Text(isqr ? 'QR 인식' : '정답 제출'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
