import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../app/theme/app_colors.dart';

// 래퍼
class AnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final StudentGrade grade;
  final VoidCallback onNext;

  const AnswerPopup({
    super.key,
    required this.isCorrect,
    required this.grade,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return UnifiedAnswerDialog(
      isCorrect: isCorrect,
      onConfirm: onNext,
    );
  }
}

// 구현체
class UnifiedAnswerDialog extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onConfirm;

  const UnifiedAnswerDialog({
    super.key,
    required this.isCorrect,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 이미지 + 배경 컬러 박스
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: isCorrect ? Color(0xFFEFFBFA) : Color(0xFFFFE8E8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        isCorrect 
                          ? "assets/images/common/successFuri.png"
                          : "assets/images/common/failFuri.png",
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 텍스트 영역
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 첫 번째 줄
                  Text(
                    isCorrect ? "정답이야!" : "정답이 아니야!",
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: isCorrect ? AppColors.correct : AppColors.incorrect,
                    ),
                  ),
                  // 두 번째 줄
                  Text(
                    isCorrect 
                      ? "좋아, 정확하게 풀어냈어!"
                      : "다시 한 번 도전해 볼까?",
                    style: const TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: AppColors.head,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey, // 필요 시 AppColors.line 같은 프로젝트 컬러로 교체
            ),            // 하단 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 5, 24, 5),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: onConfirm,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: CustomBlue.s500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
