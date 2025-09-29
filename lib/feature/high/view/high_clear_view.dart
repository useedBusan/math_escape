import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/high_timer_service.dart';

class HighClearView extends StatelessWidget {
  final DateTime gameStartTime;
  
  const HighClearView({
    super.key,
    required this.gameStartTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: const Text(
          "역설, 혹은 모호함",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // 배경 이미지
            Positioned.fill(
              child: Image.asset(
                "assets/images/high/highComplete.png",
                fit: BoxFit.cover,
                alignment: Alignment.center,
                gaplessPlayback: true,
                cacheWidth: (size.width * MediaQuery.of(context).devicePixelRatio).toInt(),
                cacheHeight: (size.height * MediaQuery.of(context).devicePixelRatio).toInt(),
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            ),
            // 그라데이션 오버레이
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00000000),
                      Color(0x20000000),
                      Color(0x40000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // 메인 콘텐츠
            Positioned.fill(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // 캐릭터 + 말풍선 이미지
                  Center(
                    child: Image.asset(
                      "assets/images/high/highFuriClear.png",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Paratruth Space, PS를 탈출하는데 걸린 시간",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // 생각의 시간 & 몸의 시간
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TimeBox(
                        title: "생각의 시간", 
                        value: HighTimerService.instance.thinkingTime,
                      ),
                      _TimeBox(
                        title: "몸의 시간", 
                        value: HighTimerService.instance.bodyTime,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 수료증 다운로드 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F55A7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // 수료증 다운로드 기능 (추후 구현)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('수료증 다운로드 기능은 준비 중입니다.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text("수료증 다운로드"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String title;
  final String value;

  const _TimeBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}