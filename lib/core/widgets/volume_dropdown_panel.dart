import 'package:flutter/material.dart';
import '../../App/theme/app_colors.dart';
import '../services/audio_service.dart';

class VolumeDropdownPanel extends StatefulWidget {
  final VoidCallback onClose;

  const VolumeDropdownPanel({super.key, required this.onClose});

  @override
  State<VolumeDropdownPanel> createState() => _VolumeDropdownPanelState();
}

class _VolumeDropdownPanelState extends State<VolumeDropdownPanel>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  late double _characterVolume;
  late double _bgmVolume;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _characterVolume = _audioService.characterVolume;
    _bgmVolume = _audioService.bgmVolume;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xDDFFFFFF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCompactVolumeControl(
                icon: Image.asset("assets/images/high/highFuri.webp"),
                label: '캐릭터',
                value: _characterVolume,
                color: CustomPink.s500,
                onChanged: (value) {
                  setState(() => _characterVolume = value);
                  _audioService.setCharacterVolume(value);
                },
              ),
              const SizedBox(height: 10),
              _buildCompactVolumeControl(
                icon: Image.asset("assets/images/common/bgmIcon.webp"),
                label: '배경음',
                value: _bgmVolume,
                color: CustomBlue.s500,
                onChanged: (value) {
                  setState(() => _bgmVolume = value);
                  _audioService.setBgmVolume(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactVolumeControl({
    required Widget icon,
    required String label,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Container(
                //   height: 28,
                //   decoration: BoxDecoration(
                //     color: color.withValues(alpha: 0.1),
                //     shape: BoxShape.circle,
                //     boxShadow: [
                //       BoxShadow(
                //         color: color.withValues(alpha: 0.3),
                //         blurRadius: 4,
                //         offset: const Offset(0, 2),
                //       ),
                //     ],
                //   ),
                //   child: Center(child: icon),
                // ),
                // const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xCC000000),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  activeTrackColor: color,
                  inactiveTrackColor: CustomGray.darkGray,
                  thumbColor: Colors.white,
                  overlayColor: color.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0.0,
                  max: 1.0,
                ),
              ),
            ),
            Container(
              width: 56,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


