import 'package:flutter/material.dart';
import '../../constants/widget_constants.dart';
import 'common_button.dart';

/// 공통 에러 위젯
/// 일관된 에러 UI를 제공
class CommonError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final Color? iconColor;

  const CommonError({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: iconColor ?? WidgetConstants.wrongColor,
            ),
            const SizedBox(height: 16),
            Text(
              '오류가 발생했습니다',
              style: WidgetConstants.titleTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: WidgetConstants.wrongColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: WidgetConstants.contentTextStyle,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CommonButton(
                text: retryText ?? '다시 시도',
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 20),
                backgroundColor: WidgetConstants.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 네트워크 에러 위젯
class NetworkError extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NetworkError({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CommonError(
      message: message ?? '네트워크 연결을 확인해주세요.',
      onRetry: onRetry,
      icon: Icons.wifi_off,
      iconColor: WidgetConstants.wrongColor,
    );
  }
}

/// QR 스캔 에러 위젯
class QRScanError extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const QRScanError({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CommonError(
      message: message ?? 'QR 코드를 인식할 수 없습니다.',
      onRetry: onRetry,
      icon: Icons.qr_code_scanner,
      iconColor: WidgetConstants.wrongColor,
      retryText: '다시 스캔',
    );
  }
}

/// 권한 에러 위젯
class PermissionError extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const PermissionError({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CommonError(
      message: message ?? '카메라 권한이 필요합니다.',
      onRetry: onRetry,
      icon: Icons.camera_alt,
      iconColor: WidgetConstants.wrongColor,
      retryText: '권한 설정',
    );
  }
}

/// 데이터 로딩 에러 위젯
class DataLoadError extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const DataLoadError({super.key, this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    return CommonError(
      message: message ?? '데이터를 불러올 수 없습니다.',
      onRetry: onRetry,
      icon: Icons.data_usage,
      iconColor: WidgetConstants.wrongColor,
      retryText: '다시 시도',
    );
  }
}
