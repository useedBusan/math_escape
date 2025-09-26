import 'package:flutter/material.dart';
import 'dart:async';
import 'package:math_escape/Feature/high/model/high_mission_answer.dart';
import 'package:math_escape/Feature/high/model/high_mission_question.dart';
import '../../../Feature/high/view/high_mission.dart';
import 'widgets/unified_truth_page.dart';

class HighAnswer extends StatefulWidget {
  final MissionAnswer answer; //답안 데이터
  final DateTime gameStartTime; //게임시작시간
  final List<MissionQuestion> questionList; //문제 목록
  final int currentIndex; //현재 문제 인덱스

  const HighAnswer({
    super.key,
    required this.answer,
    required this.gameStartTime,
    required this.questionList,
    required this.currentIndex,
  });

  @override
  State<HighAnswer> createState() => _HighAnswerState();
}

//상태 관리
//1. 타이머 관리
//2. 시간 계산 thinkingTime, body time
class _HighAnswerState extends State<HighAnswer> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.gameStartTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(widget.gameStartTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get thinkingTime {
    final minutes = _elapsed.inMinutes;
    final seconds = _elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get bodyTime {
    final totalSeconds = _elapsed.inSeconds;
    final c = totalSeconds ~/ 60;
    final d = (totalSeconds % 60) ~/ 5;
    return '$c년, $d개월';
  }

  void _showGameCompletionDialog() {
    final totalTime = DateTime.now().difference(widget.gameStartTime);
    final minutes = totalTime.inMinutes;
    final seconds = totalTime.inSeconds % 60;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('게임 완료!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('모든 문제를 완료했습니다!'),
              const SizedBox(height: 16),
              Text(
                '총 소요 시간: ${minutes}분 ${seconds}초',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pop(); // HighAnswer 닫기
                Navigator.of(context).pop(); // HighMission 닫기 (메인 화면으로 돌아가기)
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void handleNextButton() {
    final answerId = widget.answer.id;

    // 진리3 페이지인지 확인 (문제 3번의 진리 페이지)
    if (widget.answer.title.endsWith('_3') || widget.answer.title == '진리_3') {
      // 문제 3번의 진리 페이지에서 다음 문제로 버튼을 누르면 문제 4번으로 이동
      final idx = widget.questionList.indexWhere((qq) => qq.id == 6);
      if (idx != -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: idx,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      }
    }
    // 힌트 문제인지 확인 (A, B 등으로 끝나는 경우)
    else if (widget.answer.title.endsWith('_A') ||
        widget.answer.title.endsWith('_B')) {
      // 힌트 문제의 경우 원래 문제로 돌아가기
      // A는 문제 1번으로, B는 문제 3번으로 돌아가기
      int targetQuestionId;
      if (widget.answer.title.endsWith('_A')) {
        targetQuestionId = 1; // 문제 1번
      } else if (widget.answer.title.endsWith('_B')) {
        targetQuestionId = 4; // 문제 3번 (id: 4)
      } else {
        targetQuestionId = answerId - 1; // 기본적으로 이전 문제로
      }

      final idx = widget.questionList.indexWhere(
        (qq) => qq.id == targetQuestionId,
      );
      if (idx != -1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: idx,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      }
    } else {
      // 일반 문제의 경우 다음 문제로 이동
      // 진리_1 페이지인 경우 문제 2번으로 직접 이동
      if (widget.answer.title == '진리_1') {
        final idx = widget.questionList.indexWhere(
          (qq) => qq.id == 3,
        ); // 문제 2번 (id: 3)
        if (idx != -1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HighMission(
                questionList: widget.questionList,
                currentIndex: idx,
                gameStartTime: widget.gameStartTime,
              ),
            ),
          );
        }
      } else if (widget.currentIndex + 1 < widget.questionList.length) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HighMission(
              questionList: widget.questionList,
              currentIndex: widget.currentIndex + 1,
              gameStartTime: widget.gameStartTime,
            ),
          ),
        );
      } else {
        // 마지막 문제 완료 - 게임 종료 처리
        _showGameCompletionDialog();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnifiedTruthPage(
      answer: widget.answer,
      gameStartTime: widget.gameStartTime,
      questionList: widget.questionList,
      currentIndex: widget.currentIndex,
      onNextButton: handleNextButton,
      thinkingTime: thinkingTime,
      bodyTime: bodyTime,
      progress: 0.0,
    );
  }
}
