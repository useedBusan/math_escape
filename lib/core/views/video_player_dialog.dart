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

  const _ChewieDialog({required this.source, required this.isNetwork});

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    try {
      final vp = widget.isNetwork
          ? VideoPlayerController.networkUrl(Uri.parse(widget.source))
          : VideoPlayerController.asset(widget.source);

      await vp.initialize();
      final chewie = ChewieController(
        videoPlayerController: vp,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
      );

      if (!mounted) {
        unawaited(vp.dispose());
        try { chewie.dispose(); } catch (_) {}
        return;
      }

      setState(() {
        _vp = vp;
        _chewie = chewie;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    final c = _chewie;
    final v = _vp;
    _chewie = null;
    _vp = null;
    if (c != null) {
      try { c.pause(); } catch (_) {}
      try { c.dispose(); } catch (_) {}
    }
    if (v != null) {
      unawaited(v.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aspect = (_vp?.value.aspectRatio ?? 0) > 0
        ? _vp!.value.aspectRatio
        : 16 / 9;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.black,
      child: AspectRatio(
        aspectRatio: aspect,
        child: Stack(
          children: [
            if (_chewie != null) Chewie(controller: _chewie!),
            if (_loading)
              Center(
                child: Lottie.asset(
                  'assets/animations/furiAppearance.json',
                  width: 120,
                  height: 120,
                  repeat: true,
                ),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


