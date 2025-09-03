import 'package:flutter/material.dart';
import '../Model/elementary_low_mission_model.dart';


class ElementaryLowMissionList extends StatelessWidget {
  final ElementaryLowMissionModel missionItem;
  final int selectedIdx;
  final ValueChanged<int> onSelect;

  const ElementaryLowMissionList({
    super.key,
    required this.missionItem,
    required this.selectedIdx,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            missionItem.title,
            style: TextStyle(
              fontFamily: 'SBAggro',
              fontSize: w * (18/360),
              fontWeight: FontWeight.w700,
              color: Colors.black
            )
          ),
          const SizedBox(height: 10),
          Text(
            missionItem.question,
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.4,
              fontSize: w * (16 / 360),
              color: const Color(0xff333333),
            ),
          ),
          const SizedBox(height: 12),
          if (missionItem.questionImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(missionItem.questionImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(missionItem..length, (i) {
              final isSelected = i == selectedIndex;
              return _ChoiceChipBox(
                label: item.choices[i],
                selected: isSelected,
                onTap: () => onSelect(i),
              );
            }),
          ),
        ],
      )
    )
  }
}

// 수정중