import 'package:flutter/material.dart';
import 'package:math_escape/App/theme/app_colors.dart';
import '../view_model/high_timer_service.dart';
import '../view_model/high_mission_view_model.dart';
import '../view_model/high_hint_view_model.dart';
import '../view_model/high_answer_view_model.dart';
import '../../../core/views/home_alert.dart';
import '../../../core/services/audio_service.dart';
import 'package:gal/gal.dart';
import 'package:flutter/services.dart' show rootBundle;

class HighClearView extends StatefulWidget {
  final DateTime gameStartTime;

  const HighClearView({super.key, required this.gameStartTime});

  @override
  State<HighClearView> createState() => _HighClearViewState();
}

class _HighClearViewState extends State<HighClearView> {
  final AudioService _audio = AudioService();
  Future<void> _saveCertificate() async {
    try {
      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
        if (!await Gal.hasAccess()) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('권한이 거부되어 저장할 수 없습니다.')),
          );
          return;
        }
      }
      final data = await rootBundle.load('assets/images/common/certificateHigh.webp');
      final bytes = data.buffer.asUint8List();
      final String name = 'certificate_high_${DateTime.now().millisecondsSinceEpoch}.webp';
      await Gal.putImageBytes(bytes, name: name, album: 'Math Escape');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('수료증이 갤러리에 저장되었습니다.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // 클리어 축하 음성 재생
    _audio.playCharacterAudio('assets/audio/high/highCongratulation.mp3');
  }

  @override
  void dispose() {
    _audio.stopCharacter();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final alertResult = await HomeAlert.show(context);
          if (alertResult == true && context.mounted) {
            // 모든 상태 해제
            HighMissionViewModel.instance.disposeAll();
            HighHintViewModel.instance.disposeAll();
            HighAnswerViewModel.instance.disposeAll();
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () async {
              final result = await HomeAlert.show(context);
              if (result == true && context.mounted) {
                // 모든 상태 해제
                HighMissionViewModel.instance.disposeAll();
                HighHintViewModel.instance.disposeAll();
                HighAnswerViewModel.instance.disposeAll();
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
          ),
          title: const Text(
            "역설, 혹은 모호함",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFE8F0FE),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 상단 콘텐츠 영역
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 화면 중간에 위치
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        "assets/images/high/highFuriClear.webp",
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Paratruth Space,PS를 탈출하는 데 걸린 시간",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Pretendard",
                          color: CustomBlue.s500,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _InfoCard(
                        title: "생각의 시간",
                        value: HighTimerService.instance.thinkingTime,
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        title: "몸의 시간",
                        value: HighTimerService.instance.bodyTime,
                      ),
                    ],
                  ),
                ),

                // 하단 버튼
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomBlue.s500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveCertificate,
                      child: const Text(
                        "수료증 다운로드",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Color(0x4DFFFFFF),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xDD000000)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CustomBlue.s500,
            ),
          ),
        ],
      ),
    );
  }
}
