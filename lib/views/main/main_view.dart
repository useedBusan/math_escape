import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../../constants/app_constants.dart';
import '../../models/content_item.dart';
import '../../widgets/school_level_card.dart';
import '../../widgets/content_card.dart';

/// 메인 화면의 View (UI만 담당)
class MainView extends StatelessWidget {
  final MainViewModel viewModel;

  const MainView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<MainViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단 로고
                    _buildLogoSection(),
                    const SizedBox(height: 32),

                    // 학년별 카드 섹션
                    _buildSchoolLevelsSection(context, vm),
                    const SizedBox(height: 32),

                    // 홈페이지 섹션
                    _buildHomepageSection(vm),
                    const SizedBox(height: 32),

                    // 콘텐츠 섹션
                    _buildContentSection(vm),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 로고 섹션 빌드
  Widget _buildLogoSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Image.asset(
          AppConstants.logoImage,
          width: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// 학년별 카드 섹션 빌드
  Widget _buildSchoolLevelsSection(BuildContext context, MainViewModel vm) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.schoolLevels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final level = AppConstants.schoolLevels[index];
          return SchoolLevelCard(
            level: level,
            onTap: () => vm.onSchoolLevelCardTap(context, level),
          );
        },
      ),
    );
  }

  /// 홈페이지 섹션 빌드
  Widget _buildHomepageSection(MainViewModel vm) {
    return GestureDetector(
      onTap: () => vm.launchHomepage(),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppConstants.visualImage,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '>> 홈페이지 바로가기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 콘텐츠 섹션 빌드
  Widget _buildContentSection(MainViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '기타 콘텐츠',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 235,
          child: PageView.builder(
            controller: vm.pageController,
            itemCount: vm.contentList.length,
            onPageChanged: vm.onPageChanged,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ContentCard(
                  item: vm.contentList[index],
                  onTap: () => vm.onContentCardTap(vm.contentList[index]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildPageIndicator(vm),
      ],
    );
  }

  /// 페이지 인디케이터 빌드
  Widget _buildPageIndicator(MainViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(vm.contentList.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: vm.currentPage == index
                ? Colors.blueAccent
                : Colors.grey[300],
          ),
        );
      }),
    );
  }
}
