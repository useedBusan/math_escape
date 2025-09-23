import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../app/theme/app_colors.dart';

Future<void> showFullscreenVideo(BuildContext context, String source) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => FullscreenVideoPage(source: source),
    ),
  );
}

class FullscreenVideoPage extends StatefulWidget {
  final String source;
  final bool lockLandscape;
  const FullscreenVideoPage({
    super.key,
    required this.source,
    this.lockLandscape = true,
  });

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage>
    with WidgetsBindingObserver {
  late final VideoPlayerController _controller;
  bool _inited = false;
  bool _showControls = true;
  Object? _error;

  // 재개 조건 판단용
  bool _wasPlayingBeforePause = false;
  bool _exiting = false;

  bool get _isNetwork {
    final uri = Uri.tryParse(widget.source);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enterFullscreen();

    try {
      _controller = _isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(widget.source))
          : VideoPlayerController.asset(widget.source);

      _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _inited = true;
          _error = null;
        });
        if (mounted) {
          _controller.play();
        }
      }).catchError((e) {
        if (!mounted) return;
        setState(() => _error = e);
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 화면이 사라지거나 포그라운드에서 벗어날 때 Codec 이벤트가 늦게 도착하는 문제 완화
    if (!_inited || !mounted) return;
    
    try {
      if (state == AppLifecycleState.paused) {
        _wasPlayingBeforePause = _controller.value.isPlaying;
        _controller.pause();
      } else if (state == AppLifecycleState.resumed) {
        if (mounted && _wasPlayingBeforePause) {
          _controller.play();
        }
      }
    } catch (e) {
      // 앱 생명주기 변경 중 에러 발생 시 무시
      debugPrint('Video player lifecycle error: $e');
    }
  }

  Future<void> _enterFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (widget.lockLandscape) {
        await SystemChrome.setPreferredOrientations(const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } catch (e) {
      debugPrint('Error entering fullscreen mode: $e');
      // 전체화면 모드 설정 실패해도 비디오 재생은 계속 진행
    }
  }

  Future<void> _exitFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      if (widget.lockLandscape) {
        await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      }
    } catch (e) {
      debugPrint('Error exiting fullscreen mode: $e');
      // 전체화면 모드 해제 실패해도 앱이 크래시되지 않도록 처리
    }
  }

  Future<void> _handleClose(BuildContext context) async {
    if (_exiting) return;
    _exiting = true;
    
    try {
      // 해제 직전 먼저 일시정지 → Surface 사용 중단 유도
      if (_inited && _controller.value.isPlaying) {
        await _controller.pause();
      }
    } catch (e) {
      debugPrint('Error pausing video on close: $e');
    }
    
    // 나머지는 dispose에서 정리
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    try {
      // UI → Surface → Codec 순으로 내려가도록 우선 화면 상태 복구
      unawaited(_exitFullscreen());
      // Controller가 Surface/Codec 해제까지 담당
      _controller.dispose();
    } catch (e) {
      debugPrint('Error disposing video controller: $e');
    }
    
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
                child: _error != null
                    ? _ErrorBox(error: _error!)
                    : _inited
                    ? AspectRatio(
                  aspectRatio: aspect,
                  child: VideoPlayer(_controller),
                )
                    : const SizedBox(
                  width: 56,
                  height: 56,
                  child:
                  CircularProgressIndicator(color: Colors.white),
                ),
              ),
              if (_showControls) _buildTopBar(context),
              if (_showControls && _inited && _error == null)
                _buildBottomControls(),
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
              iconSize: 28,
              color: Colors.white,
              onPressed: () => _handleClose(context),
              icon: const Icon(Icons.close),
              tooltip: '닫기',
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  try {
                    final playing = _controller.value.isPlaying;
                    if (playing) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    if (mounted) setState(() {});
                  } catch (e) {
                    debugPrint('Error toggling video playback: $e');
                  }
                },
                icon: Icon(_controller.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill),
                tooltip:
                _controller.value.isPlaying ? '일시 정지' : '재생',
              ),
              const SizedBox(width: 24),
              IconButton(
                iconSize: 28,
                color: Colors.white,
                onPressed: () {
                  try {
                    final v = _controller.value;
                    final pos = v.position;
                    final target = Duration.zero > pos - const Duration(seconds: 10)
                        ? Duration.zero
                        : pos - const Duration(seconds: 10);
                    _controller.seekTo(target);
                  } catch (e) {
                    debugPrint('Error seeking backward: $e');
                  }
                },
                icon: const Icon(Icons.replay_10),
                tooltip: '10초 뒤로',
              ),
              const SizedBox(width: 8),
              IconButton(
                iconSize: 28,
                color: Colors.white,
                onPressed: () {
                  try {
                    final v = _controller.value;
                    final duration = v.duration ?? Duration.zero;
                    final pos = v.position;
                    final target = (pos + const Duration(seconds: 10)) > duration
                        ? duration
                        : pos + const Duration(seconds: 10);
                    _controller.seekTo(target);
                  } catch (e) {
                    debugPrint('Error seeking forward: $e');
                  }
                },
                icon: const Icon(Icons.forward_10),
                tooltip: '10초 앞으로',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final Object error;
  const _ErrorBox({required this.error});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          '영상을 불러오는 중 문제가 발생했습니다.\n$error',
          style: const TextStyle(color: Colors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}