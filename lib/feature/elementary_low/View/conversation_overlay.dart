import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/speaker_enums.dart';
import '../../../core/utils/view/common_intro_view.dart';
import '../../../core/utils/viewmodel/intro_view_model.dart';

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
      await viewModel.loadTalks('assets/data/elem_low/elem_low_conversation.json');
      viewModel.setStageTalks(widget.stage);
      print('DEBUG: Conversation loaded for stage ${widget.stage}, talks count: ${viewModel.talks.length}');
      if (widget.isFinalConversation) {
        print('DEBUG: Final conversation - stage: ${widget.stage}, talks: ${viewModel.talks.length}');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading conversation: $e');
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
                      appBarTitle: "미션! 수사모의 수학 보물을 찾아서",
                      backgroundAssetPath: talk.backImg,
                      characterImageAssetPath: widget.isFinalConversation 
                          ? 'assets/images/common/puri_clear.png' 
                          : talk.speakerImg,
                      speakerName: speakerName(),
                      talkText: talk.talk,
                      buttonText: "다음",
                      grade: StudentGrade.elementaryLow,
                      // stage 7 (id: 27)에서만 furiClear 애니메이션 표시
                      lottieAnimationPath: widget.stage == 7 
                          ? 'assets/animations/furiClear.json' 
                          : null,
                      showLottieInsteadOfImage: widget.stage == 7,
                      onNext: () {
                        print('DEBUG: ConversationOverlay onNext - canGoNext: ${vm.canGoNext()}, currentIdx: ${vm.currentIdx}, totalCount: ${vm.totalCount}');
                        if (vm.canGoNext()) {
                          vm.goToNextTalk();
                        } else {
                          print('DEBUG: ConversationOverlay onNext - calling onComplete');
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
