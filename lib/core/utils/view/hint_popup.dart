import 'package:flutter/material.dart';
import 'package:math_escape/core/utils/view/show_full_screen_video.dart';
import '../model/hint_model.dart';

class HintPopup extends StatelessWidget {
  final HintModel model;
  final VoidCallback onConfirm;
  final String confirmText;
  final bool showColoredBar;

  const HintPopup({
    super.key,
    required this.model,
    required this.onConfirm,
    this.confirmText = '확인',
    this.showColoredBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final height = mq.size.height;
    final headerSize = width * (18 / 360);
    final baseSize = width * (17 / 360);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40)
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: height * 0.55,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 360,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      model.hintIcon,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      model.upString,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: headerSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff202020),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      model.downString,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseSize,
                        color: const Color(0xff202020),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (model.hintImg != null)
                      _HintImage(path: model.hintImg!)
                    else if (model.hintVideo != null)
                      _VideoPreviewButton(
                        onTap: () => showFullscreenVideo(
                          context,
                          model.hintVideo!,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: model.mainColor,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
                onPressed: onConfirm,
                child: Text(
                  confirmText,
                  style: TextStyle(fontSize: baseSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _HintImage extends StatelessWidget {
  final String path;
  const _HintImage({required this.path});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 180),
      child: Center(
        child: Image.asset(path, fit: BoxFit.contain),
      ),
    );
  }
}

class _VideoPreviewButton extends StatelessWidget {
  final VoidCallback onTap;
  const _VideoPreviewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.play_circle_fill, size: 64, color: Colors.white.withValues(alpha: 0.95)),
            const Positioned(
              bottom: 10,
              child: Text('영상 보기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}