import 'package:flutter/material.dart';
import '../services/service_locator.dart';

class SoundControlBottomSheet extends StatefulWidget {
  const SoundControlBottomSheet({super.key});

  @override
  State<SoundControlBottomSheet> createState() => _SoundControlBottomSheetState();
}

class _SoundControlBottomSheetState extends State<SoundControlBottomSheet> {
  double _bgmVolume = serviceLocator.audioService.bgmVolume;
  bool _bgmMuted = false;
  double _lastNonZeroVolume = 0.5;

  @override
  void initState() {
    super.initState();
    _bgmMuted = _bgmVolume == 0.0;
    if (!_bgmMuted) {
      _lastNonZeroVolume = _bgmVolume;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '사운드 설정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 16),

            // 배경음 컨트롤
            Row(
              children: [
                const Text(
                  '배경음',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const Spacer(),
                Switch(
                  value: !_bgmMuted,
                  onChanged: (on) async {
                    setState(() {
                      _bgmMuted = !on;
                      if (_bgmMuted) {
                        _lastNonZeroVolume = _bgmVolume == 0 ? 0.5 : _bgmVolume;
                        _bgmVolume = 0.0;
                      } else {
                        _bgmVolume = _lastNonZeroVolume;
                      }
                    });
                    await serviceLocator.audioService.setBgmVolume(_bgmVolume);
                  },
                ),
              ],
            ),
            Slider(
              min: 0,
              max: 1,
              value: _bgmVolume,
              onChanged: (value) async {
                setState(() {
                  _bgmVolume = value;
                  _bgmMuted = value == 0.0;
                  if (value > 0) _lastNonZeroVolume = value;
                });
                await serviceLocator.audioService.setBgmVolume(value);
              },
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}


