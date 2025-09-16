// hint_popup.dart
import 'package:flutter/material.dart';
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
    final width = MediaQuery.of(context).size.width;
    final baseSize = width * (16 / 360);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상단 이미지
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Image.asset(
                      model.img,
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      model.upString,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff202020),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      model.downString,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: baseSize,
                        color: const Color(0xff202020),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              if (showColoredBar)
                Container(
                  height: 12,
                  width: double.infinity,
                  color: model.mainColor,
                )
              else
                const Divider(height: 1, thickness: 1, color: Color(0xFFDDDDDD)),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: onConfirm,
                  style: TextButton.styleFrom(
                    foregroundColor: model.mainColor,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(confirmText, style: TextStyle(fontSize: baseSize)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showHintPopup({
  required BuildContext context,
  required HintModel model,
  required VoidCallback onConfirm,
  String confirmText = '확인',
  bool barrierDismissible = true,
  bool showColoredBar = true,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => HintPopup(
      model: model,
      onConfirm: onConfirm,
      confirmText: confirmText,
      showColoredBar: showColoredBar,
    ),
  );
}