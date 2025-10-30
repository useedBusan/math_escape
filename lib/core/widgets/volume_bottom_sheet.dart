import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../services/audio_service.dart';

class VolumeBottomSheet extends StatefulWidget {
  const VolumeBottomSheet({super.key});

  @override
  State<VolumeBottomSheet> createState() => _VolumeBottomSheetState();
}

class _VolumeBottomSheetState extends State<VolumeBottomSheet> {
  final AudioService _audioService = AudioService();
  late double _characterVolume;
  late double _bgmVolume;

  @override
  void initState() {
    super.initState();
    _characterVolume = _audioService.characterVolume;
    _bgmVolume = _audioService.bgmVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '음량 조절',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildVolumeControl(
            icon: Image.asset("assets/images/high/highFuri.webp"),
            label: '캐릭터',
            value: _characterVolume,
            color: CustomPink.s500,
            onChanged: (value) {
              setState(() => _characterVolume = value);
              _audioService.setCharacterVolume(value);
            },
          ),
          const SizedBox(height: 32),
          _buildVolumeControl(
            icon: Image.asset("assets/images/common/bgmIcon.webp"),
            label: '배경음',
            value: _bgmVolume,
            color: CustomBlue.s500,
            onChanged: (value) {
              setState(() => _bgmVolume = value);
              _audioService.setBgmVolume(value);
            },
          ),
          const SizedBox(height: 24),
          Text(
            '슬라이더를 좌우로 움직여 음량을 조절하세요',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl({
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: icon),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  fontSize: 14,
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
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
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


