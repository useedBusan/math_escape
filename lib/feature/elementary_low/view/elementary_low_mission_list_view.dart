import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/elementary_low_mission_model.dart';
import '../view_model/elementary_low_mission_view_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/extensions/string_extension.dart';

class ElementaryLowMissionListView extends StatelessWidget {
  const ElementaryLowMissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ElementaryLowMissionViewModel>();

    if (!vm.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final ElementaryLowMissionModel? mission = vm.currentMission;
    if (mission == null) {
      return const Center(child: Text('불러올 미션이 없습니다.'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: vm.progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(CustomPink.s500),
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
                  text: ' / ${vm.missions.length}',
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
                fontFamily: 'Pretendard',
                fontSize: 17,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.body,
              ),
              children: mission.question.toStyledSpans(fontSize: 17),
            ),
          ),
          // QR 문제가 아닐 때만 이미지와 선택 버튼 표시
          if (!mission.isqr) ...[
            if (mission.questionImage != null) ...[
              const SizedBox(height: 12),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 이미지의 원본 비율을 유지하면서 사용 가능한 공간에 맞춤
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          mission.questionImage!,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth,
                          // 높이는 이미지의 원본 비율에 따라 자동으로 결정됨
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20), // 이미지와 버튼 사이 일정한 패딩
            ],
            const SizedBox(height: 12), // 버튼 위 일정한 패딩
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
                final isSelected = vm.selectedChoiceIndex == i;
                return _ChoiceChipBox(
                  label: mission.choices[i],
                  selected: isSelected,
                  enabled: !vm.isLoading,
                  onTap: () => vm.selectChoice(i),
                );
              },
            ),
          ] else ...[
            // QR 문제일 때는 빈 공간 확보
            const Expanded(child: SizedBox()),
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
              color: selected ? CustomPink.s500 : const Color(0xFFDCDCDC),
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