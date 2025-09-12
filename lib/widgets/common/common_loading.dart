import 'package:flutter/material.dart';
import '../../constants/widget_constants.dart';

/// 공통 로딩 위젯
/// 일관된 로딩 UI를 제공
class CommonLoading extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;
  final bool showMessage;

  const CommonLoading({
    super.key,
    this.message,
    this.size,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? WidgetConstants.primaryColor,
            ),
            strokeWidth: 3.0,
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: WidgetConstants.contentTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// 전체 화면 로딩 오버레이
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoading({super.key, this.message, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: CommonLoading(message: message ?? '로딩 중...', showMessage: true),
    );
  }
}

/// 버튼 내부 로딩
class ButtonLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const ButtonLoading({super.key, this.size = 16.0, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
      ),
    );
  }
}

/// QR 스캔 로딩
class QRScanLoading extends StatelessWidget {
  final String message;

  const QRScanLoading({super.key, this.message = 'QR 코드를 스캔하고 있습니다...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3.0,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
