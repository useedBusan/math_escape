import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 로티 애니메이션을 표시하는 공통 위젯
class LottieAnimationWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool reverse;
  final BoxFit fit;
  final Alignment alignment;
  final VoidCallback? onLoaded;

  const LottieAnimationWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.repeat = true,
    this.reverse = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.onLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      assetPath,
      width: width,
      height: height,
      repeat: repeat,
      reverse: reverse,
      fit: fit,
      alignment: alignment,
      onLoaded: onLoaded != null ? (_) => onLoaded!() : null,
    );
  }
}

/// 로티 애니메이션을 표시하는 확장 위젯 (컨트롤러 포함)
class LottieAnimationController extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final bool repeat;
  final bool reverse;
  final BoxFit fit;
  final Alignment alignment;
  final VoidCallback? onLoaded;

  const LottieAnimationController({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.repeat = true,
    this.reverse = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.onLoaded,
  });

  @override
  State<LottieAnimationController> createState() => _LottieAnimationControllerState();
}

class _LottieAnimationControllerState extends State<LottieAnimationController>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void play() {
    _controller.forward();
  }

  void pause() {
    _controller.stop();
  }

  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.assetPath,
      controller: _controller,
      width: widget.width,
      height: widget.height,
      repeat: widget.repeat,
      reverse: widget.reverse,
      fit: widget.fit,
      alignment: widget.alignment,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        widget.onLoaded?.call();
      },
    );
  }
}
