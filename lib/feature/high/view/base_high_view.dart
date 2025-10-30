import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/base_high_view_model.dart';
import '../../../app/theme/app_colors.dart';


typedef HighPaneBuilder = Widget Function(BuildContext, HighPane);

class BaseHighView extends StatelessWidget {
  const BaseHighView({
    super.key,
    required this.title,
    required this.paneBuilder,
    this.mainColor = CustomBlue.s500,
    this.background,
    this.onBack,
    this.onHome,
    this.useStack = false,
    this.transitionDuration = const Duration(milliseconds: 220),
  });

  final String title;
  final Color mainColor;
  final Widget? background;
  final VoidCallback? onBack;
  final VoidCallback? onHome;
  final bool useStack;
  final Duration transitionDuration;

  final HighPaneBuilder paneBuilder;

  @override
  Widget build(BuildContext context) {
    // BaseHighViewModel의 pane 정보만 필요하므로 Selector 사용
    return Selector<BaseHighViewModel, HighPane>(
      selector: (context, vm) => vm.pane,
      builder: (context, pane, child) {
        Widget mid = Padding(
          padding: const EdgeInsets.all(16),
          child: useStack
              ? Stack(children: [Positioned.fill(child: paneBuilder(context, pane))])
              : AnimatedSwitcher(
            duration: transitionDuration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(pane),
              child: paneBuilder(context, pane),
            ),
          ),
        );

        final appBar = AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: mainColor, size: 28),
            onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            title,
            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            if (onHome != null)
              IconButton(icon: Icon(Icons.home, color: mainColor, size: 28), onPressed: onHome),
          ],
        );

        return Stack(
          children: [
            if (background != null) Positioned.fill(child: background!),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              appBar: appBar,
              body: Stack(
                children: [
                  // 메인 컨텐츠
                  Positioned.fill(
                    child: SafeArea(
                      top: false,
                      bottom: false, // 하단바가 따로 SafeArea 처리
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: mid,
                      ),
                    ),
                  ),

                  // 하단바: 화면 좌우/아래 딱 붙게 (타이머만 별도 Consumer로 분리)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Consumer<BaseHighViewModel>(
                      builder: (context, vm, child) {
                        return _BottomTimerBar(
                          mainColor: vm.progressColor,
                          think: vm.thinkText,
                          body: vm.bodyText,
                          progress: vm.thinkProgress,
                          hourglassAsset: 'assets/images/high/highHourglass.png',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomTimerBar extends StatelessWidget {
  const _BottomTimerBar({
    required this.mainColor,
    required this.think,
    required this.body,
    this.progress = 0.0,
    required this.hourglassAsset,
  });

  final Color mainColor;
  final String think;
  final String body;
  final double progress;
  final String hourglassAsset;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final double circleSize = h * 0.1;
    final double barHeight  = circleSize * 0.65;

    return SizedBox(
      width: double.infinity,
      height: circleSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: barHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _kv('생각의 시간', think, isBoldKey: false, textAlign: TextAlign.left),
                  _kv('몸의 시간', body, isBoldKey: true, textAlign: TextAlign.right),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: circleSize,
              height: circleSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(circleSize, circleSize),
                    painter: _RingPainter(
                      background: const Color(0xFFE2E6F2),
                      foreground: mainColor,
                      progress: progress.clamp(0.0, 1.0),
                      strokeWidth: circleSize * 0.11,
                    ),
                  ),
                  Container(
                    width: circleSize * 0.8,
                    height: circleSize * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      hourglassAsset,
                      width: circleSize * 0.47,
                      height: circleSize * 0.47,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
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
      TextSpan(children: [
        TextSpan(text: key, style: keyStyle),
        const TextSpan(text: ' '),
        TextSpan(text: value, style: valStyle),
      ]),
      textAlign: textAlign,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// 중앙 원형 링 그리기
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