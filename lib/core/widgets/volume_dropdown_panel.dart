import 'package:flutter/material.dart';
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
          width: 288,
          decoration: BoxDecoration(
            color: Colors.white,
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
                icon: '🎭',
                label: '캐릭터',
                value: _characterVolume,
                color: const Color(0xFF3B82F6),
                backgroundColor: const Color(0xFFEC4899),
                onChanged: (value) {
                  setState(() => _characterVolume = value);
                  _audioService.setCharacterVolume(value);
                },
              ),
              const SizedBox(height: 24),
              _buildCompactVolumeControl(
                icon: Icons.music_note,
                label: '배경음',
                value: _bgmVolume,
                color: const Color(0xFFA855F7),
                backgroundColor: const Color(0xFFA855F7),
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
    required dynamic icon,
    required String label,
    required double value,
    required Color color,
    required Color backgroundColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor,
                        backgroundColor.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: backgroundColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: icon is IconData
                        ? Icon(icon, color: Colors.white, size: 16)
                        : Text(icon, style: const TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            Container(
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
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            activeTrackColor: color,
            inactiveTrackColor: const Color(0xFFE5E7EB),
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
      ],
    );
  }
}


