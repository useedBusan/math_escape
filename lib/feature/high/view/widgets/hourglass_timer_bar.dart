import 'package:flutter/material.dart';

/// 모래시계 타이머 바 위젯
class HourglassTimerBar extends StatelessWidget {
  const HourglassTimerBar({
    super.key,
    required this.mainColor,
    required this.think,
    required this.body,
    this.progress = 0.0,
    this.hourglassAsset = 'assets/images/common/hintIcon.png',
  });

  final Color mainColor;
  final String think;
  final String body;
  final double progress;
  final String hourglassAsset;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double circleSize = screenHeight * 0.08;
    final double barHeight = screenHeight * 0.08;

    return Container(
      width: double.infinity,
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // 연한 회색 배경
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 좌측: 생각의 시간
          _buildTimeText('생각의 시간', think),

          // 중앙: 모래시계 + 진행률
          _buildHourglassWithProgress(circleSize),

          // 우측: 몸의 시간
          _buildTimeText('몸의 시간', body),
        ],
      ),
    );
  }

  Widget _buildTimeText(String label, String value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourglassWithProgress(double circleSize) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 원형 배경
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // 연한 파란색
              shape: BoxShape.circle,
            ),
          ),

          // 진행률 표시 (상단에 작은 세그먼트)
          CustomPaint(
            size: Size(circleSize, circleSize),
            painter: _ProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              color: mainColor,
            ),
          ),

          // 모래시계 아이콘
          Container(
            width: circleSize * 0.6,
            height: circleSize * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_empty,
              size: circleSize * 0.4,
              color: const Color(0xFF8B4513), // 갈색 모래시계
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(
    String key,
    String value, {
    bool isBoldKey = false,
    TextAlign textAlign = TextAlign.start,
  }) {
    final keyStyle = TextStyle(
      fontSize: 15,
      fontWeight: isBoldKey ? FontWeight.w700 : FontWeight.w600,
      color: const Color(0xFF202020),
    );
    final valStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: Color(0xFF202020),
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: key, style: keyStyle),
          const TextSpan(text: ' '),
          TextSpan(text: value, style: valStyle),
        ],
      ),
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// 상단 진행률 세그먼트 그리기
class _ProgressPainter extends CustomPainter {
  _ProgressPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.15;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // 상단에 작은 세그먼트로 진행률 표시 (12시 방향부터)
    final startAngle = -90 * (3.1415926535 / 180.0); // 12시 방향
    final sweepAngle = 2 * 3.1415926535 * progress; // 진행률에 따른 각도

    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter old) =>
      old.progress != progress || old.color != color;
}

/// 중앙 원형 링 그리기 (기존 코드 유지)
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.background,
    required this.foreground,
    required this.progress,
    this.strokeWidth = 6,
  });

  final Color background;
  final Color foreground;
  final double progress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final bg = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // 배경 원
    canvas.drawCircle(center, radius, bg);

    // 진행률 (12시 방향부터 시계방향)
    final start = -90 * (3.1415926535 / 180.0);
    final sweep = 2 * 3.1415926535 * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, start, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.background != background ||
      old.foreground != foreground ||
      old.strokeWidth != strokeWidth;
}
