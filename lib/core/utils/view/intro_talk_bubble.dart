// 사용하지 않는 파일 - CommonIntroView가 대신 사용됨
/*
import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/utils/model/talk_model.dart';

class TalkBubble extends StatelessWidget {
  final Talk talk;
  final StudentGrade grade;
  final VoidCallback onNext;

  const TalkBubble({
    super.key,
    required this.talk,
    required this.grade,
    required this.onNext,
  });

  Color _mainColor() {
    switch (grade) {
      case StudentGrade.elementaryLow:
        return const Color(0xffB73D5D);
      case StudentGrade.middle:
        return const Color(0xff2B4193);
      default:
        return Colors.white;
    }
  }

  String _speakerName() {
    switch (talk.speaker) {
      case Speaker.puri:
        return "푸리";
      case Speaker.maemae:
        return "매매";
      case Speaker.book:
        return "수첩";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _mainColor(), width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: SingleChildScrollView(
            child: Text(
              talk.talk,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * (15 / 360),
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ),

        // 이름표
        Positioned(
          top: 0,
          left: 20,
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _mainColor(),
              border: Border.all(color: const Color(0xffffffff), width: 1.5),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              _speakerName(),
              style: TextStyle(
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width * (16 / 360),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // 다음 버튼
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.play_circle,
                color: _mainColor(), size: 32),
            onPressed: onNext,
          ),
        ),
      ],
    );
  }
}
*/