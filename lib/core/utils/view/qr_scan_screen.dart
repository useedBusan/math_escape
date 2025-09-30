// QR 코드 인식 (mobile_scanner 기반)

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  late final MobileScannerController _controller;
  bool _scanned = false;  //scan되었는지 확인하는 부분

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      // 필요 시 옵션들:
      // facing: CameraFacing.back,
      // detectionSpeed: DetectionSpeed.normal, // or noDuplicates
      // torchEnabled: false,
      formats: [BarcodeFormat.qrCode],
    );

    // QR 스캔 데이터는 _onDetect에서 처리됩니다
  }

  @override
  void reassemble() {
    super.reassemble();
    // hot reload 시 카메라 재시작
    _controller.stop();
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    print(
      "📷 QR Detection Attempt: ${capture.barcodes.length} barcodes detected",
    );

    for (final barcode in capture.barcodes) { //카에라 캡쳐에 인식된 모든 바코드/QR리스트 순회
      final value = barcode.rawValue; //QR코드의 원시값 추출, 인코딩된 문자열 값
      final rawBytes = barcode.rawBytes;  //QR코드의 바이너리 데이터 원본(문자열로 디코딩되기 전 상태)
      //디버그 로그 출력
      print(
        "📷 QR Scan Raw Value: '$value' (length: ${value?.length}, format: ${barcode.format})",
      );
      print("📷 QR Scan Raw Bytes: $rawBytes (length: ${rawBytes?.length})");

      if (value != null && value.isNotEmpty) {  //값이 유효하다면
        print("🎯 QR Detection Success: '$value' (format: ${barcode.format})");  //로그 출력
        _scanned = true;
        Navigator.of(context).pop(value); //현재 화면 닫으면서 스캔결과를 호출한 쪽에 반환
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cutOut = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(title: const Text('QR 코드 스캔')),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 카메라 뷰
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(child: Text('카메라 오류: $error'));
            },
          ),

          // 오버레이 (qr_code_scanner의 QrScannerOverlayShape 대체)
          IgnorePointer(
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),
          IgnorePointer(
            child: SizedBox(
              width: cutOut,
              height: cutOut,
              child: CustomPaint(
                painter: _CornerBorderPainter(
                  borderColor: Colors.blue,
                  borderWidth: 6,
                  cornerLen: 28,
                  radius: 12,
                ),
              ),
            ),
          ),

          // 하단 안내
          Positioned(
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'QR 코드를 사각형 안에 맞춰주세요',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 모서리 테두리만 그려주는 페인터 (간단 오버레이)
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

    // 모서리만 그리기
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
