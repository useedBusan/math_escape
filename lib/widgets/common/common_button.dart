import 'package:flutter/material.dart';
import '../../constants/widget_constants.dart';

/// 공통 버튼 위젯
/// 일관된 스타일의 버튼을 제공
class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final Widget? icon;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.textStyle,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? WidgetConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? WidgetConstants.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ??
                BorderRadius.circular(WidgetConstants.borderRadius),
          ),
          elevation: 2,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    text,
                    style: textStyle ?? WidgetConstants.buttonTextStyle,
                  ),
                ],
              ),
      ),
    );
  }
}

/// QR 스캔 버튼
class QRScanButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const QRScanButton({
    super.key,
    this.onPressed,
    this.text = 'QR코드 촬영',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      icon: const Icon(Icons.qr_code_scanner, size: 20),
      backgroundColor: WidgetConstants.primaryColor,
      isLoading: isLoading,
    );
  }
}

/// 힌트 버튼
class HintButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const HintButton({
    super.key,
    this.onPressed,
    this.text = '힌트',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      icon: const Icon(Icons.lightbulb_outline, size: 20),
      backgroundColor: WidgetConstants.secondaryColor,
      isLoading: isLoading,
    );
  }
}

/// 답안 제출 버튼
class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const SubmitButton({
    super.key,
    this.onPressed,
    this.text = '답안 제출',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      icon: const Icon(Icons.check, size: 20),
      backgroundColor: WidgetConstants.correctColor,
      isLoading: isLoading,
    );
  }
}

/// 다음 버튼
class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const NextButton({
    super.key,
    this.onPressed,
    this.text = '다음',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward, size: 20),
      backgroundColor: WidgetConstants.primaryColor,
      isLoading: isLoading,
    );
  }
}
