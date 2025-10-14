import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


Future<void> showVideoPlayerDialog(
    BuildContext context, {
      required String source,
      bool isNetwork = false,
    }) async {
  if (!context.mounted) return;

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => _ChewieDialog(
      source: source,
      isNetwork: isNetwork,
    ),
  );
}

class _ChewieDialog extends StatefulWidget {
  final String source;
  final bool isNetwork;

  const _ChewieDialog({
    required this.source,
    required this.isNetwork,
  });

  @override
  State<_ChewieDialog> createState() => _ChewieDialogState();
}

class _ChewieDialogState extends State<_ChewieDialog> {
  VideoPlayerController? _vp;
  ChewieController? _chewie;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init(); // 바로 호출 (PostFrameCallback 불필요)
  }

  Future<void> _init() async {
    try {
      final vp = widget.isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(widget.source))
          : VideoPlayerController.asset(widget.source);

      await vp.initialize();
      if (!mounted) {
        await vp.dispose();
        return;
      }

      final chewie = ChewieController(
        videoPlayerController: vp,
        autoPlay: true,
        looping: false,
        allowFullScreen: false,
        allowMuting: true,
        showControls: true,
      );

      if (!mounted) {
        await vp.dispose();
        chewie.dispose();
        return;
      }

      setState(() {
        _vp = vp;
        _chewie = chewie;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      debugPrint('Video init error: $e');
    }
  }

  @override
  void dispose() {
    _chewie?.pause();
    _chewie?.dispose();
    _vp?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspect = (_vp?.value.aspectRatio ?? 0) > 0
        ? _vp!.value.aspectRatio
        : 16 / 9;

    return PopScope(
      canPop: true,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: aspect,
          child: _loading
              ? Center(
            child: Lottie.asset(
              'assets/animations/loadingIndicator.json',
              width: 300,
              repeat: true,
            ),
          )
              : Stack(
            children: [
              Chewie(controller: _chewie!),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}