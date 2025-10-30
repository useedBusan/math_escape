import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../constants/enum/grade_enums.dart';
import '../../../core/views/answer_popup.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/views/qr_scan_screen.dart';

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
    this.onHome,
    this.onQRScanned,
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
  final VoidCallback? onHome;
  final Future<bool> Function(String)? onQRScanned; // QR 스캔 결과 처리 콜백

  // view
  @override
  Widget build(BuildContext context) {
    final mainColor = grade.mainColor;
    final bannerImgPath = grade.bannerImg;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomButtonHeight = 104.0; // 60 + 24*2 (padding)

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            color: mainColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mainColor, size: 28),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: mainColor, size: 28),
            onPressed: () {
              HomeAlert.showAndNavigate(context, onHome: onHome);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable content area
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (bannerImgPath != null)
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset(bannerImgPath, fit: BoxFit.cover),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: missionBuilder(context),
                  ),
                  SizedBox(
                    height: math.max(keyboardHeight, bottomButtonHeight),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
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
                              barrierDismissible: false,
                              builder: hintDialogueBuilder,
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/common/hintIcon.webp",
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '힌트',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
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
                            final nav = Navigator.of(context);
                            final dialogContext = context;

                            if (isqr) {
                              // QR 문제일 때
                              final result = await nav.push(
                                MaterialPageRoute(
                                  builder: (_) => const QRScanScreen(),
                                ),
                              );

                              if (result != null &&
                                  result is String &&
                                  onQRScanned != null) {
                                final isCorrect = await onQRScanned!(result);

                                if (!dialogContext.mounted) return;

                                showDialog(
                                  context: dialogContext,
                                  barrierDismissible: false,
                                  builder: (_) => AnswerPopup(
                                    isCorrect: isCorrect,
                                    grade: grade,
                                    onNext: () {
                                      Navigator.of(dialogContext).pop();
                                      if (isCorrect) {
                                        onCorrect?.call();
                                      } else {
                                        onWrong?.call();
                                      }
                                    },
                                  ),
                                );
                              }
                            } else {
                              // 일반 문제일 때
                              final ok = await onSubmitAnswer(dialogContext);
                              if (!dialogContext.mounted) return;

                              showDialog(
                                context: dialogContext,
                                barrierDismissible: false,
                                builder: (_) => AnswerPopup(
                                  isCorrect: ok,
                                  grade: grade,
                                  onNext: () {
                                    Navigator.of(dialogContext).pop();
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
                              Text(
                                isqr ? 'QR 인식' : '정답 제출',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
