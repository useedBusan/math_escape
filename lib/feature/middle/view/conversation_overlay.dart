import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/views/common_intro_view.dart';
import '../../../core/viewmodels/intro_view_model.dart';
import '../../../core/models/talk_model.dart';

class ConversationOverlay extends StatefulWidget {
  final int stage;
  final VoidCallback onComplete;
  final VoidCallback onCloseByBack;
  final bool isFinalConversation;

  const ConversationOverlay({
    super.key,
    required this.stage,
    required this.onComplete,
    required this.onCloseByBack,
    this.isFinalConversation = false,
  });

  @override
  State<ConversationOverlay> createState() => _ConversationOverlayState();
}

class _ConversationOverlayState extends State<ConversationOverlay> {
  late IntroViewModel viewModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    try {
      viewModel = IntroViewModel();
      
      // Middle 대화 데이터를 직접 로드하고 변환
      final String jsonString = await rootBundle.loadString('assets/data/middle/middle_conversation.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Middle 데이터 구조를 Elementary 형태로 변환
      final List<Talk> talks = [];
      for (final item in jsonList) {
        if (item['id'] == widget.stage && item['talks'] != null) {
          final List<dynamic> stageTalks = item['talks'];
          for (int i = 0; i < stageTalks.length; i++) {
            final talkData = stageTalks[i];
            talks.add(Talk(
              id: widget.stage * 100 + i,
              speaker: Speaker.puri, // Middle은 항상 푸리
              speakerImg: talkData['furiImage'] ?? 'assets/images/common/furiStanding.png',
              backImg: talkData['backImage'] ?? 'assets/images/common/bsbackground.png',
              talk: talkData['talk'] ?? '',
            ));
          }
          break;
        }
      }
      
      viewModel.talks = talks;
      viewModel.currentIdx = 0;
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: isLoading
        ? const Center(child: CircularProgressIndicator())
        : viewModel.talks.isEmpty
            ? _buildEmptyState()
            : ChangeNotifierProvider.value(
                value: viewModel,
                child: Consumer<IntroViewModel>(
                  builder: (context, vm, child) {
                    final talk = vm.currentTalk;
                    
                    String speakerName() {
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

                    return CommonIntroView(
                      appBarTitle: StudentGrade.middle.appBarTitle,
                      backgroundAssetPath: talk.backImg,
                      characterImageAssetPath: widget.isFinalConversation 
                          ? 'assets/images/common/puri_clear.png' 
                          : talk.speakerImg,
                      speakerName: speakerName(),
                      talkText: talk.talk,
                      buttonText: "다음",
                      grade: StudentGrade.middle,
                      // 최종 대화에서만 furiClear 애니메이션 표시 (stage는 middle 데이터에 따라 조정)
                      lottieAnimationPath: widget.isFinalConversation 
                          ? 'assets/animations/furiClear.json' 
                          : null,
                      showLottieInsteadOfImage: widget.isFinalConversation,
                      onNext: () {
                        if (vm.canGoNext()) {
                          vm.goToNextTalk();
                        } else {
                          widget.onComplete();
                        }
                      },
                      onBack: () {
                        if (vm.canGoPrevious()) {
                          vm.goToPreviousTalk();
                        } else {
                          widget.onCloseByBack();
                        }
                      },
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        '대화가 없습니다.',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
