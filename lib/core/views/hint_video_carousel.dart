import 'package:flutter/material.dart';
import 'package:math_escape/core/views/video_player_dialog.dart';

/// 여러 개의 힌트 비디오를 슬라이드 형태로 보여주는 캐러셀 위젯
class HintVideoCarousel extends StatefulWidget {
  final List<String> videos;

  const HintVideoCarousel({super.key, required this.videos});

  @override
  State<HintVideoCarousel> createState() => _HintVideoCarouselState();
}

class _HintVideoCarouselState extends State<HintVideoCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _goTo(int index) {
    if (index < 0 || index >= widget.videos.length) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.videos.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => showVideoPlayerDialog(
                      context,
                      source: widget.videos[index],
                      isNetwork: false,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF121212),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.play_circle_fill,
                            size: 64, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_currentIndex > 0)
              Positioned(
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  onPressed: () => _goTo(_currentIndex - 1),
                ),
              ),
            if (_currentIndex < widget.videos.length - 1)
              Positioned(
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white, size: 32),
                  onPressed: () => _goTo(_currentIndex + 1),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16), // 동영상 밑에 여백 추가
      ],
    );
  }
}