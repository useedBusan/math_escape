import 'package:flutter/material.dart';
import '../../constants/widget_constants.dart';

/// 통합된 정답/오답 팝업 위젯
/// 모든 학년에서 사용할 수 있는 유연한 AnswerPopup
class CommonAnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback? onNext;
  final String? customTitle;
  final String? customMessage;
  final String? buttonText;
  final Color? buttonColor;
  final bool showNextButton;

  const CommonAnswerPopup({
    super.key,
    required this.isCorrect,
    this.onNext,
    this.customTitle,
    this.customMessage,
    this.buttonText,
    this.buttonColor,
    this.showNextButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: WidgetConstants.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetConstants.borderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * WidgetConstants.dialogWidth,
        padding: const EdgeInsets.only(top: WidgetConstants.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: WidgetConstants.padding,
              ),
              child: Column(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    size: WidgetConstants.iconSize,
                    color: isCorrect
                        ? WidgetConstants.correctColor
                        : WidgetConstants.wrongColor,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: WidgetConstants.titleTextStyle,
                      children: [
                        TextSpan(
                          text: _getTitle(),
                          style: isCorrect
                              ? WidgetConstants.correctTextStyle
                              : WidgetConstants.wrongTextStyle,
                        ),
                        TextSpan(text: _getTitleSuffix()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getMessage(),
                    style: WidgetConstants.contentTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Divider(
              height: 1,
              thickness: 1,
              color: WidgetConstants.dividerColor,
            ),
            SizedBox(
              width: double.infinity,
              height: WidgetConstants.buttonHeight,
              child: TextButton(
                onPressed: onNext ?? () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: buttonColor ?? WidgetConstants.primaryColor,
                  textStyle: WidgetConstants.buttonTextStyle,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  buttonText ?? (isCorrect ? '다음' : '확인'),
                  style: WidgetConstants.buttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    if (customTitle != null) return customTitle!;
    return isCorrect ? '정답' : '오답';
  }

  String _getTitleSuffix() {
    if (customTitle != null) return '';
    return isCorrect ? '입니다!' : '입니다.';
  }

  String _getMessage() {
    if (customMessage != null) return customMessage!;
    return isCorrect ? '조금만 더 풀면 탈출할 수 있어요!' : '다시 한번 생각해 볼까요?';
  }
}

/// 초등학교 고학년용 AnswerPopup
class ElementaryHighAnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onNext;

  const ElementaryHighAnswerPopup({
    super.key,
    required this.isCorrect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAnswerPopup(
      isCorrect: isCorrect,
      onNext: onNext,
      customTitle: isCorrect ? '정답' : '오답',
      customMessage: isCorrect ? '보물에 한 걸음 더 가까워졌어!' : '다시 한 번 생각해볼까?',
      buttonColor: WidgetConstants.secondaryColor,
    );
  }
}

/// 중학교용 AnswerPopup
class MiddleAnswerPopup extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onNext;

  const MiddleAnswerPopup({
    super.key,
    required this.isCorrect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return CommonAnswerPopup(
      isCorrect: isCorrect,
      onNext: onNext,
      customTitle: isCorrect ? '정답' : '오답',
      customMessage: isCorrect ? '조금만 더 풀면 탈출할 수 있어요!' : '다시 한번 생각해 볼까요?',
      buttonColor: WidgetConstants.primaryColor,
    );
  }
}

/// 기본 AnswerPopup (기존 호환성 유지)
class BasicAnswerPopup extends StatelessWidget {
  final bool isCorrect;

  const BasicAnswerPopup({super.key, required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return CommonAnswerPopup(
      isCorrect: isCorrect,
      showNextButton: false,
      customTitle: isCorrect ? '정답입니다!' : '오답입니다.',
      customMessage: isCorrect ? '조금만 더 풀면 탈출할 수 있어요!' : '다시 한번 생각해 볼까요?',
    );
  }
}
