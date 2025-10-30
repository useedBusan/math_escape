import 'package:flutter/material.dart';
import 'volume_bottom_sheet.dart';

class VolumeButtonBottomSheet extends StatelessWidget {
  final Color? buttonColor;
  final Color? iconColor;
  final double? buttonSize;

  const VolumeButtonBottomSheet({
    super.key,
    this.buttonColor,
    this.iconColor,
    this.buttonSize = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showVolumeBottomSheet(context),
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.volume_up,
          size: buttonSize! * 0.5,
          color: iconColor ?? const Color(0xFF374151),
        ),
      ),
    );
  }

  void _showVolumeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VolumeBottomSheet(),
    );
  }
}


