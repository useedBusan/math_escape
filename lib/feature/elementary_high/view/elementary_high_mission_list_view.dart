import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../view_model/elementary_high_mission_view_model.dart';
import '../../../core/extensions/string_extension.dart';

class ElementaryHighMissionListView extends StatelessWidget {
  const ElementaryHighMissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ElementaryHighMissionViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!vm.hasMission) {
      return const Center(child: Text('불러올 미션이 없습니다.'));
    }

    final mission = vm.currentMission!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: vm.progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffD95276)),
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '문제 ${vm.currentIndex + 1}',
                  style: TextStyle(
                    fontFamily: 'SBAggroM',
                    fontSize: 18,
                    color: AppColors.head,
                  ),
                ),
                TextSpan(
                  text: ' / ${vm.totalCount}',
                  style: TextStyle(
                    fontFamily: 'SBAggroM',
                    fontSize: 15,
                    color: CustomGray.darkGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                height: 1.5,
                fontSize: 18,
                color: const Color(0xff333333),
              ),
              children: mission.question.toStyledSpans(fontSize: 18),
            ),
          ),
          // QR 문제가 아닐 때만 텍스트 입력 표시
          if (!mission.isqr) ...[
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: const Color(0xffdcdcdc)),
              ),
              child: TextField(
                controller: vm.textController,
                onChanged: vm.setTypedAnswer,
                style: TextStyle(
                  fontSize: 15,
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                decoration: InputDecoration(
                  hintText: '정답을 입력해 주세요.',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: const Color(0xffaaaaaa),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: Color(0xffaaaaaa)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: Color(0xffD95276), width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (mission.questionImage != null) ...[
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.asset(
                        mission.questionImage!,
                        fit: BoxFit.contain,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          // QR 문제가 아닐 때만 보기 선택 버튼 표시
          if (!mission.isqr) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 60,
              ),
              itemCount: mission.choices.length,
              itemBuilder: (context, i) {
                final selected = vm.selectedChoiceIndex == i;
                return _ChoiceChipBox(
                  label: mission.choices[i],
                  selected: selected,
                  enabled: !vm.isBusy,
                  onTap: () => vm.selectChoice(i),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChipBox extends StatelessWidget {
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _ChoiceChipBox({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFFFF2) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xffD95276) : const Color(0xFFDCDCDC),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: null,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}


