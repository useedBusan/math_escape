import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/views/common_intro_view.dart';
import '../../../core/viewmodels/intro_view_model.dart';
import '../../../core/models/talk_model.dart';
import '../../../core/services/service_locator.dart';

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
  int maxStage = 0;

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  Future<void> _loadConversation() async {
    try {
      viewModel = IntroViewModel();
      final String jsonString = await rootBundle.loadString('assets/data/middle/middle_conversation.json');
      final List<dynamic> jsonList = json.decode(jsonString);

      final List<Talk> talks = [];
      for (final item in jsonList) {
        if (item['id'] == widget.stage && item['talks'] != null) {
          final List<dynamic> stageTalks = item['talks'];
          for (int i = 0; i < stageTalks.length; i++) {
            final talkData = stageTalks[i];
            talks.add(Talk(
              id: widget.stage * 100 + i,
              speaker: Speaker.puri,
              speakerImg: talkData['furiImage'] ?? 'assets/images/common/furiStanding.webp',
              backImg: talkData['backImage'] ?? 'assets/images/common/bsbackground.webp',
              talk: talkData['talk'] ?? '',
              voice: talkData['voice'] as String?,
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

      // 첫 프레임 렌더 후 현재 보이스 재생을 한 번 더 보장
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // 오디오 플레이어가 준비될 때까지 짧은 딜레이 추가
        await Future.delayed(const Duration(milliseconds: 200));
        if (!mounted) return;
        if (viewModel.talks.isNotEmpty) {
          final String? firstVoice = viewModel.talks.first.voice;
          if (firstVoice == null || firstVoice.isEmpty) {
            serviceLocator.audioService.stopCharacter();
          } else {
            // audio_service에서 자동으로 재시도 처리함
            await serviceLocator.audioService.playCharacterAudio(firstVoice);
          }
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // 대화 종료 시 보이스 중단 및 뷰모델 정리
    viewModel.dispose();
    super.dispose();
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
                      characterImageAssetPath: talk.speakerImg,
                      speakerName: speakerName(),
                      talkText: talk.talk,
                      buttonText: "다음",
                      grade: StudentGrade.middle,
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
