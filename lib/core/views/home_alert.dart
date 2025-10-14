import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// 홈화면 이동 확인을 위한 커스텀 Alert 모듈
class HomeAlert {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CustomHomeAlertDialog(),
    );
  }

  static Future<void> showAndNavigate(
    BuildContext context, {
    VoidCallback? onHome,
  }) async {
    final result = await show(context);
    
    if (result == true) {
      if (onHome != null) {
        onHome();
      } else if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }
}

class _CustomHomeAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 이미지
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  "assets/images/common/mainHigh.png",
                  width: 120,
                  height: 120,
                ),
              ),
              
              // 텍스트 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "잠깐! ",
                            style: TextStyle(
                              color: CustomPink.s500,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: "지금 나가면 기록은 사라져.\n그래도 탐험을 중단할 거야?",
                            style: TextStyle(
                              color: AppColors.head,
                              fontFamily: "Pretendard",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              
              // 하단 버튼들
              Row(
                children: [
                  // 왼쪽 버튼: 탐험 중단
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: CustomGray.lightGray,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // 탐험 중단
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        child: Text(
                          "탐험 중단",
                          style: TextStyle(
                            color: CustomBlue.s500,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // 오른쪽 버튼: 계속 탐험
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: CustomBlue.s500,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // 계속 탐험
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                        ),
                        child: Text(
                          "계속 탐험",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}