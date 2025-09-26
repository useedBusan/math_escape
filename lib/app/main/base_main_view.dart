import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/enum/grade_enums.dart';
import '../theme/app_colors.dart';
import 'base_main_view_model.dart';

class BaseMainView extends StatelessWidget {
  const BaseMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BaseMainViewModel(), //viewModel 연동
      child: Consumer<BaseMainViewModel>(
        builder: (ctx, vm, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  // 상단 로고
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/common/mainLogo.png',
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 스크롤 가능한 메인 콘텐츠
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 인사말
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '미션투어시리즈에 온 걸 환영해! 🎉',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                Text(
                                  '너만의 수학 모험을 시작해 봐!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 카드 영역
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.9,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: StudentGrade.values.map((level) {
                                return _buildLevelCard(context, vm, level);
                              }).toList(),
                            ),
                          ),

                          // 시작하기 버튼
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ElevatedButton(
                              onPressed: vm.hasSelection
                                  ? () => vm.startMission(context)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: CustomBlue.s500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                '시작하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 하단 배너 (바닥에 고정)
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/common/bannerMain.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(
      BuildContext context,
      BaseMainViewModel vm,
      StudentGrade level) {
    final isSelected = vm.selectedLevel == level; //선택 상태 관리

    return GestureDetector(
      onTap: () => vm.selectLevel(level),   //선택로직
      child: Container(
        decoration: BoxDecoration(
          color: level.backgroundColor,
          border: isSelected ? Border.all(
            color: CustomBlue.s500,
            width: 2,
          ) : null,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: CustomBlue.s500.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(level.imagePath, height: 80),
            const SizedBox(height: 12),
            Text(
              level.title,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'SBAggroM',
                color: AppColors.body,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              level.subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
                color: level.mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}