import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  late final MobileScannerController _controller;
  bool _scanned = false;
  bool _showHelper = true; // QR 헬퍼 이미지 표시 여부

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(formats: [BarcodeFormat.qrCode]);

    // 1초 뒤 QR 헬퍼 이미지 숨기기
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showHelper = false);
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        _scanned = true;
        Navigator.of(context).pop(value);
        break;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cutOut = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(title: const Text('QR코드 스캔')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 카메라 뷰
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // 가운데 뚫린 반투명 배경
          ScannerOverlay(cutOut: cutOut),

          // 모서리 프레임
          SizedBox(
            width: cutOut,
            height: cutOut,
            child: CustomPaint(
              painter: _CornerBorderPainter(
                borderColor: Colors.white,
                borderWidth: 4,
                cornerLen: 24,
                radius: 12,
              ),
            ),
          ),

          // 중앙 QR 헬퍼 이미지 (1초 뒤 사라짐)
          AnimatedOpacity(
            opacity: _showHelper ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              'assets/images/sample_qr.png', // QR 헬퍼 이미지 경로
              width: cutOut * 0.5,
            ),
          ),

          // 안내 문구
          Positioned(
            bottom: 32,
            child: const Text(
              'QR코드를 잘 보이도록 화면 안에 맞춰주세요!',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// 배경을 반투명 검정으로 덮고, 가운데 사각형만 뚫는 오버레이
class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key, required this.cutOut});
  final double cutOut;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _ScannerOverlayPainter(cutOut: cutOut),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  _ScannerOverlayPainter({required this.cutOut});
  final double cutOut;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.7);

    final full = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: cutOut,
          height: cutOut,
        ),
        const Radius.circular(12),
      ));

    // 전체에서 중앙 부분 빼기
    final overlay = Path.combine(PathOperation.difference, full, hole);
    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// 흰색 모서리 프레임 (ㄱ, ㄴ 모양)
class _CornerBorderPainter extends CustomPainter {
  _CornerBorderPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.cornerLen,
    required this.radius,
  });

  final Color borderColor;
  final double borderWidth;
  final double cornerLen;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // 좌상
    path.moveTo(r.left, r.top + cornerLen);
    path.lineTo(r.left, r.top + radius);
    path.quadraticBezierTo(r.left, r.top, r.left + radius, r.top);
    path.lineTo(r.left + cornerLen, r.top);

    // 우상
    path.moveTo(r.right - cornerLen, r.top);
    path.lineTo(r.right - radius, r.top);
    path.quadraticBezierTo(r.right, r.top, r.right, r.top + radius);
    path.lineTo(r.right, r.top + cornerLen);

    // 좌하
    path.moveTo(r.left, r.bottom - cornerLen);
    path.lineTo(r.left, r.bottom - radius);
    path.quadraticBezierTo(r.left, r.bottom, r.left + radius, r.bottom);
    path.lineTo(r.left + cornerLen, r.bottom);

    // 우하
    path.moveTo(r.right - cornerLen, r.bottom);
    path.lineTo(r.right - radius, r.bottom);
    path.quadraticBezierTo(r.right, r.bottom, r.right, r.bottom - radius);
    path.lineTo(r.right, r.bottom - cornerLen);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBorderPainter oldDelegate) {
    return borderColor != oldDelegate.borderColor ||
        borderWidth != oldDelegate.borderWidth ||
        cornerLen != oldDelegate.cornerLen ||
        radius != oldDelegate.radius;
  }
}