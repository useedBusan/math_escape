import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/elementary_low_mission_model.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';

class ElementaryLowMissionListView extends StatelessWidget {
  const ElementaryLowMissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = ElementaryLowMissionViewModel.instance;

    return AnimatedBuilder(
      animation: vm,
      builder: (context, _) {
        if (!vm.isLoaded) {
          return const Center(child: CircularProgressIndicator());
        }
        final ElementaryLowMissionModel? mission = vm.currentMission;
        if (mission == null) {
          return const Center(child: Text('불러올 미션이 없습니다.'));
        }

        final w = MediaQuery.of(context).size.width;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목
              Text(
                mission.title,
                style: TextStyle(
                  fontFamily: 'SBAggro',
                  fontSize: w * (18 / 360),
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // 질문
              Text(
                mission.question,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  height: 1.4,
                  fontSize: w * (16 / 360),
                  color: const Color(0xff333333),
                ),
              ),
              const SizedBox(height: 12),

              // 이미지
              if (mission.questionImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    mission.questionImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 선택지
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(mission.choices.length, (i) {
                  final bool isSelected = vm.selectedChoiceIndex == i;
                  return _ChoiceChipBox(
                    label: mission.choices[i],
                    selected: isSelected,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      vm.selectChoice(i);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16),

              // 제출 결과
              if (vm.lastSubmitCorrect != null)
                _ResultBanner(correct: vm.lastSubmitCorrect!),

              const SizedBox(height: 8),

              // 하단 네비게이션
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: vm.currentIndex > 0 ? vm.previousMission : null,
                      child: const Text('이전'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: vm.canSubmit ? vm.submitAnswer : null,
                      child: vm.isSubmitting
                          ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Text('제출'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (vm.currentIndex < vm.missions.length - 1)
                          ? vm.nextMission
                          : null,
                      child: const Text('다음'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChoiceChipBox extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChipBox({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.blue : const Color(0xffDDDDDD),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : const Color(0xff333333),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final bool correct;
  const _ResultBanner({required this.correct});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: correct ? const Color(0xFFE7F7E9) : const Color(0xFFFFEFEF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: correct ? const Color(0xFF9ED9A4) : const Color(0xFFFFB3B3),
        ),
      ),
      child: Text(
        correct ? '정답이에요! 잘했어요 👏' : '아쉬워요! 다시 도전해볼까요?',
        style: TextStyle(
          color: correct ? const Color(0xFF1D7A2E) : const Color(0xFFB71C1C),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}