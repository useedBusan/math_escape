import 'package:flutter/material.dart';
import 'package:math_escape/widgets/ReuseView/intro_talk_bubble.dart';
import '../../../models/elementary_low/talk_model.dart';
import '../ViewModel/elementary_low_intro_view_model.dart';
import 'elementary_low_mission_view.dart';

class ElementaryLowIntroView extends StatefulWidget {
  const ElementaryLowIntroView({super.key});

  @override
  State<ElementaryLowIntroView> createState() => _ElementaryLowIntroViewState();
}

class _ElementaryLowIntroViewState extends State<ElementaryLowIntroView> {
  final viewModel = ElementaryLowIntroViewModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel.loadTalks().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Properties
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.talks.isEmpty) {
      return const Scaffold(body: Center(child: Text('표시할 항목이 없습니다.')));
    }

    // View
    return Scaffold(
        appBar: AppBar(
          title: const Text("미션! 수학자의 수첩을 찾아서"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xffD95276),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xffD95276),
              size: 28,
            ),
            onPressed: () {
              if (viewModel.canGoPrevious()) {
                setState(() {
                  viewModel.goToPreviousTalk();
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final bodyHeight = constraints.maxHeight;
          final bodyWidth = constraints.maxWidth;

          final bubbleHeight = bodyHeight * 0.32;
          final bubbleWidth = bodyWidth * 0.93;
          final characterHeight = bodyHeight * 0.38;

          final characterTop = ((bodyHeight-bubbleHeight) - characterHeight) / 2;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  viewModel.currentTalk.backImg,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0x99D95276), Color(0x99FFFFFF)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: characterTop,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    viewModel.currentTalk.speakerImg,
                    height: characterHeight,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    height: bubbleHeight,
                    width: bubbleWidth,
                    child: TalkBubble(
                      talk: viewModel.currentTalk,
                      grade: StudentGrade.elementaryLow,
                      onNext: () {
                        if (viewModel.canGoNext()) {
                          setState(() {
                            viewModel.goToNextTalk();
                          });
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const ElementaryLowMissionView(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        })
    );
  }
}