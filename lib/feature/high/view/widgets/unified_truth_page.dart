import 'package:flutter/material.dart';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import 'hourglass_timer_bar.dart';

class UnifiedTruthPage extends StatelessWidget {
  final MissionAnswer answer;
  final DateTime gameStartTime;
  final List<MissionQuestion> questionList;
  final int currentIndex;
  final VoidCallback onNextButton;
  final String thinkingTime;
  final String bodyTime;
  final double progress;

  const UnifiedTruthPage({
    super.key,
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
    required this.onNextButton,
    required this.thinkingTime,
    required this.bodyTime,
    required this.progress,
  });

  String _getButtonText() {
    // 힌트 문제인지 확인
    if (answer.title.endsWith('_A') || answer.title.endsWith('_B')) {
      return '돌아가기';
    } else {
      // 일반 문제의 경우
      if (currentIndex + 1 < questionList.length) {
        return '다음 문제로';
      } else {
        return '마지막 문제';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3F55A7)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '역설, 혹은 모호함',
          style: TextStyle(
            color: const Color(0xFF3F55A7),
            fontSize: screenWidth * (16 / 360),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFE8F0FE),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 14),
                // 설명 텍스트 (퓨리 이미지 + 텍스트) - 고정
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // 퓨리 이미지 (왼쪽)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/high/highFuri.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 텍스트 (오른쪽)
                      Expanded(
                        child: Text(
                          '인류의 처음 정수의 정수는 한 개인의\n처음 정수를 만들기 위해 가장 기본이 되는 것,\n곧, 정수!',
                          style: TextStyle(
                            fontFamily: "SBAggroM",
                            fontSize: screenWidth * (14 / 360),
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 메인 콘텐츠 영역 (Expanded)
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // 연한 회색 배경
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 진리 제목
                        Text(
                          answer.title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 설명 텍스트 (explanation 사용)
                        Text(
                          answer.explanation,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 문구의 단서 박스 (clue 사용)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B6B6B), // 진한 회색
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                answer.clueTitle,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                answer.clue,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.white,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // 다음 문제로 버튼
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: onNextButton,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F55A7),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _getButtonText(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 하단 모래시계 타이머 (고정 위치)
                HourglassTimerBar(
                  mainColor: const Color(0xFF3F55A7),
                  think: thinkingTime,
                  body: bodyTime,
                  progress: progress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
