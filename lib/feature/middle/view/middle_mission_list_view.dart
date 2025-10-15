import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/middle_mission_model.dart';
import '../view_model/middle_mission_view_model.dart';
import '../../../app/theme/app_colors.dart';

class MiddleMissionListView extends StatelessWidget {
  const MiddleMissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MiddleMissionViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final MissionItem? mission = vm.currentMission;
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
              valueColor: AlwaysStoppedAnimation<Color>(CustomBlue.s500),
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

          Text(
            mission.question,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: AppColors.body,
            ),
          ),

          // 이미지가 있을 때 표시
          ...[
            const SizedBox(height: 12),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        mission.questionImage,
                        fit: BoxFit.contain,
                        width: constraints.maxWidth,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // QR 문제가 아닐 때만 입력 필드 표시
          if (!mission.isqr) ...[
            const SizedBox(height: 12),
            TextField(
              controller: vm.answerController,
              decoration: InputDecoration(
                hintText: '답을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF3F55A7)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
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
