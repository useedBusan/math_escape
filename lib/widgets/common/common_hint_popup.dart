import 'package:flutter/material.dart';
import '../../constants/widget_constants.dart';

/// 통합된 힌트 팝업 위젯
/// 모든 학년에서 사용할 수 있는 유연한 HintDialog
class CommonHintPopup extends StatelessWidget {
  final String hintTitle;
  final String hintContent;
  final VoidCallback? onConfirm;
  final String? buttonText;
  final Color? buttonColor;
  final String? iconAsset;
  final IconData? iconData;
  final double? iconSize;

  const CommonHintPopup({
    super.key,
    required this.hintTitle,
    required this.hintContent,
    this.onConfirm,
    this.buttonText,
    this.buttonColor,
    this.iconAsset,
    this.iconData,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WidgetConstants.borderRadius),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * WidgetConstants.dialogWidth,
        decoration: BoxDecoration(
          color: WidgetConstants.backgroundColor,
          borderRadius: BorderRadius.circular(WidgetConstants.borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20.0,
                20.0,
                20.0,
                WidgetConstants.padding,
              ),
              child: Column(
                children: [
                  _buildIcon(),
                  const SizedBox(height: 18),
                  Text(hintTitle, style: WidgetConstants.titleTextStyle),
                  const SizedBox(height: 2),
                  Text(
                    hintContent,
                    textAlign: TextAlign.center,
                    style: WidgetConstants.contentTextStyle,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: WidgetConstants.buttonHeight,
              decoration: BoxDecoration(
                color: buttonColor ?? WidgetConstants.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(WidgetConstants.borderRadius),
                  bottomRight: Radius.circular(WidgetConstants.borderRadius),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm?.call();
                },
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(WidgetConstants.borderRadius),
                      bottomRight: Radius.circular(
                        WidgetConstants.borderRadius,
                      ),
                    ),
                  ),
                ),
                child: Text(
                  buttonText ?? '확인',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: WidgetConstants.buttonFontSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (iconAsset != null) {
      return Image.asset(
        iconAsset!,
        width: iconSize ?? WidgetConstants.iconSize,
        height: iconSize ?? WidgetConstants.iconSize,
      );
    }

    if (iconData != null) {
      return Icon(
        iconData!,
        size: iconSize ?? WidgetConstants.iconSize,
        color: WidgetConstants.primaryColor,
      );
    }

    // 기본 아이콘
    return Image.asset(
      'assets/images/bulb.png',
      width: iconSize ?? WidgetConstants.iconSize,
      height: iconSize ?? WidgetConstants.iconSize,
    );
  }
}

/// 초등학교 고학년용 HintDialog
class ElementaryHighHintPopup extends StatelessWidget {
  final String hintTitle;
  final String hintContent;

  const ElementaryHighHintPopup({
    super.key,
    required this.hintTitle,
    required this.hintContent,
  });

  @override
  Widget build(BuildContext context) {
    return CommonHintPopup(
      hintTitle: hintTitle,
      hintContent: hintContent,
      iconAsset: 'assets/images/hint_puri.png',
      buttonColor: WidgetConstants.secondaryColor,
    );
  }
}

/// 중학교용 HintDialog
class MiddleHintPopup extends StatelessWidget {
  final String hintTitle;
  final String hintContent;
  final VoidCallback? onConfirm;

  const MiddleHintPopup({
    super.key,
    required this.hintTitle,
    required this.hintContent,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CommonHintPopup(
      hintTitle: hintTitle,
      hintContent: hintContent,
      onConfirm: onConfirm,
      iconAsset: 'assets/images/bulb.png',
      buttonColor: WidgetConstants.primaryColor,
    );
  }
}

/// 기본 HintDialog
class BasicHintPopup extends StatelessWidget {
  final String hintTitle;
  final String hintContent;
  final VoidCallback? onConfirm;

  const BasicHintPopup({
    super.key,
    required this.hintTitle,
    required this.hintContent,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CommonHintPopup(
      hintTitle: hintTitle,
      hintContent: hintContent,
      onConfirm: onConfirm,
      iconData: Icons.lightbulb_outline,
    );
  }
}
