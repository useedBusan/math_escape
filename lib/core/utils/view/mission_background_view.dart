import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../core/utils/view/answer_popup.dart';
import '../../../core/utils/view/qr_scan_screen.dart';
import '../../../core/services/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../feature/elementary_high/view_model/elementary_high_mission_view_model.dart';
import '../../../feature/elementary_low/ViewModel/elementary_low_mission_view_model.dart';

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
                          // 초등학교 고학년 또는 저학년일 때 실제 QR 스캔 수행
                          if (grade == StudentGrade.elementaryHigh ||
                              grade == StudentGrade.elementaryLow) {
                            await _handleQRScanForElementary(context);
                          } else {
                            // 다른 학년은 기존 로직 유지 (바로 정답 처리)
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
                          }
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

  /// 초등학교용 QR 스캔 처리 함수 (저학년, 고학년 공통)
  Future<void> _handleQRScanForElementary(BuildContext context) async {
    try {
      // 카메라 권한 요청
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('카메라 권한이 필요합니다.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // QR 스캔 화면으로 이동
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QRScanScreen()),
      );

      if (!context.mounted) return;

      if (result != null && result is String) {
        // QR 스캔 결과를 정답과 비교
        final isCorrect = await _validateQRAnswer(context, result);

        // 정답/오답 팝업 표시
        showDialog(
          context: context,
          builder: (context) => AnswerPopup(
            isCorrect: isCorrect,
            grade: grade,
            onNext: () {
              Navigator.of(context).pop();
              if (isCorrect) {
                onCorrect?.call();
              } else {
                onWrong?.call();
              }
            },
          ),
        );
      }
    } catch (e) {
      print('QR 스캔 오류: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR 스캔 중 오류가 발생했습니다.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// QR 스캔 결과를 정답과 비교하는 함수
  Future<bool> _validateQRAnswer(BuildContext context, String qrResult) async {
    try {
      // 학년에 따라 적절한 ViewModel과 학년 코드 사용
      String gradeCode;
      dynamic vm;

      if (grade == StudentGrade.elementaryLow) {
        gradeCode = 'elementary_low';
        vm = context.read<ElementaryLowMissionViewModel>();
      } else if (grade == StudentGrade.elementaryHigh) {
        gradeCode = 'elementary_high';
        vm = context.read<ElementaryHighMissionViewModel>();
      } else {
        print('지원하지 않는 학년입니다: $grade');
        return false;
      }

      // 현재 미션 가져오기
      dynamic currentMission;
      if (grade == StudentGrade.elementaryLow) {
        currentMission = vm.currentMission;
      } else {
        currentMission = vm.currentMission;
      }

      if (currentMission == null) {
        print('현재 미션을 찾을 수 없습니다.');
        return false;
      }

      // QR 정답 서비스를 통해 정답 확인
      final correctQRAnswer = serviceLocator.qrAnswerService
          .getCorrectAnswerByGrade(gradeCode, currentMission.id);

      final isCorrect = correctQRAnswer != null && qrResult == correctQRAnswer;

      print('초등학교 QR 스캔 결과: $qrResult');
      print('정답: $correctQRAnswer, 맞음: $isCorrect');

      return isCorrect;
    } catch (e) {
      print('QR 정답 검증 오류: $e');
      return false;
    }
  }
}
