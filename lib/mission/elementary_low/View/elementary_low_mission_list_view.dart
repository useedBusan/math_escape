import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/elementary_low_mission_model.dart';
import '../ViewModel/elementary_low_mission_view_model.dart';

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

    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            mission.title,
            style: TextStyle(
              fontFamily: 'SBAggro',
              fontSize: w * (16 / 360),
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: vm.progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(CustomPink.s600),
            ),
          ),
          const SizedBox(height: 24),

          // 질문
          Text(
            mission.question,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: w * (16 / 360),
              fontWeight: FontWeight.w400,
              color: AppColors.body,
            ),
          ),
          const SizedBox(height: 20),

          // 이미지
          if (mission.questionImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(mission.questionImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
          ],

          // 선택지
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 60, // 카드 높이 60 고정
            ),
            itemCount: mission.choices.length,
            itemBuilder: (context, i) {
              final isSelected = vm.selectedChoiceIndex == i;
              return _ChoiceChipBox(
                label: mission.choices[i],
                selected: isSelected,
                enabled: !vm.isLoading, // 제출 중 탭 방어
                onTap: () => vm.selectChoice(i),
              );
            },
          ),
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
              fontSize: MediaQuery.of(context).size.width * (16 / 360),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}