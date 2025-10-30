import 'package:flutter/material.dart';
import 'volume_dropdown_panel.dart';

class VolumeButtonDropdown extends StatefulWidget {
  final Color? buttonColor;
  final Color? iconColor;
  final double? buttonSize;

  const VolumeButtonDropdown({
    super.key,
    this.buttonColor,
    this.iconColor,
    this.buttonSize = 48.0,
  });

  @override
  State<VolumeButtonDropdown> createState() => _VolumeButtonDropdownState();
}

class _VolumeButtonDropdownState extends State<VolumeButtonDropdown> {
  bool _isOpen = false;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
    setState(() => _isOpen = !_isOpen);
  }

  void _showOverlay() {
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _toggleDropdown,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            top: position.dy + widget.buttonSize! + 8,
            right: MediaQuery.of(context).size.width - position.dx - widget.buttonSize!,
            child: Material(
              color: Colors.transparent,
              child: VolumeDropdownPanel(onClose: _toggleDropdown),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: _toggleDropdown,
      child: Container(
        width: widget.buttonSize,
        height: widget.buttonSize,
        decoration: BoxDecoration(
          color: (widget.buttonColor ?? Colors.white).withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.volume_up,
          size: widget.buttonSize! * 0.4,
          color: widget.iconColor ?? const Color(0xFF374151),
        ),
      ),
    );
  }
}


