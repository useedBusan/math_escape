import 'package:flutter/material.dart';
import '../models/hint_model.dart';
import 'hint_video_carousel.dart';

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
            // Scrollable content with height constraints to avoid overflow
            Flexible(
              child: ConstrainedBox(
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
                    _buildUpString(model.upString, headerSize),
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

                    if (model.hintImg != null && model.hintImg!.isNotEmpty)
                      _HintImage(path: model.hintImg!.first)
                    else if (model.hintVideo != null && model.hintVideo!.isNotEmpty)
                      HintVideoCarousel(videos: model.hintVideo!)
                    ],
                  ),
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

  Widget _buildUpString(String upString, double headerSize) {
    // "/ 숫자" 패턴을 찾아서 분리
    final match = RegExp(r' (/\s*\d+)$').firstMatch(upString);
    
    if (match != null) {
      // "/ 숫자" 부분이 있는 경우
      final beforePart = upString.substring(0, match.start);
      final afterPart = match.group(0)!; // " / 숫자" 부분
      
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: headerSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xff202020),
            height: 1.25,
          ),
          children: [
            TextSpan(text: beforePart),
            TextSpan(
              text: afterPart,
              style: TextStyle(
                fontSize: headerSize * 0.75, // 75% 크기
                color: const Color(0xFFA0A0A0), // 회색
              ),
            ),
          ],
        ),
      );
    } else {
      // "/ 숫자" 부분이 없는 경우 (예: "힌트" 또는 "푸리 힌트")
      return Text(
        upString,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: headerSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xff202020),
          height: 1.25,
        ),
      );
    }
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

// (unused old preview button removed)