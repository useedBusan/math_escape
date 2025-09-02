import 'package:flutter/material.dart';
import 'package:math_escape/widgets/ReuseView/intro_talk_bubble.dart';

import '../../../models/elementary_low/talk_model.dart';


class ElementaryLowIntroView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("미션! 수학자의 수첩을 찾아서"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xffD95276),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/bsbackground.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x99D95276),
                    Color(0x99FFFFFF),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(child: Center(
                    child: Image.asset(
                      "assets/images/puri_stand_normal.png",
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.24,
                    )
                )),
                TalkBubble(
                    talk: Talk[id],
                    grade: StudentGrade.elementaryLow,
                    onNext: () {
                      print("다음 대화로 이동");
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}