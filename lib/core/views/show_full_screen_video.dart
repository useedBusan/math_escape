import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

Future<void> showFullscreenVideo(BuildContext context, String source, {bool isNetwork = false}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => FullscreenVideoPage(source: source, isNetwork: isNetwork),
    ),
  );
}

class FullscreenVideoPage extends StatefulWidget {
  final String source;
  final bool isNetwork;

  const FullscreenVideoPage({
    super.key,
    required this.source,
    this.isNetwork = false,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> with WidgetsBindingObserver {
  late final VideoPlayerController _controller;
  bool _inited = false;
  bool _showControls = true;
  bool _wasPlayingBeforePause = false;
  bool _exiting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) => _enterFullscreen());

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = widget.isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(widget.source))
          : VideoPlayerController.asset(widget.source);

      await _controller.initialize();
      if (!mounted) return;

      setState(() => _inited = true);
      _controller.play();
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  Future<void> _enterFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint("Enter fullscreen error: $e");
    }
  }

  Future<void> _exitFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } catch (e) {
      debugPrint("Exit fullscreen error: $e");
    }
  }

  void _handleClose() async {
    if (_exiting) return;
    _exiting = true;
    try {
      await _controller.pause();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).maybePop();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_inited || !mounted) return;

    try {
      if (state == AppLifecycleState.paused) {
        _wasPlayingBeforePause = _controller.value.isPlaying;
        _controller.pause();
      } else if (state == AppLifecycleState.resumed) {
        if (_wasPlayingBeforePause) _controller.play();
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_exitFullscreen()); // 🔹 async 복귀 안전
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspect = (_inited && _controller.value.aspectRatio > 0)
        ? _controller.value.aspectRatio
        : 16 / 9;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _showControls = !_showControls),
          child: Stack(
            children: [
              Center(
                child: _inited
                    ? AspectRatio(
                  aspectRatio: aspect,
                  child: VideoPlayer(_controller),
                )
                    : const CircularProgressIndicator(color: Colors.white),
              ),
              if (_showControls) _buildTopBar(context),
              if (_showControls && _inited) _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              iconSize: 28,
              tooltip: '닫기',
              onPressed: _handleClose,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            colors: const VideoProgressColors(
              playedColor: Colors.white,
              bufferedColor: Colors.white24,
              backgroundColor: Colors.white12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  final playing = _controller.value.isPlaying;
                  if (playing) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  if (mounted) setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}