import 'package:flutter/material.dart';
import 'package:math_escape/mission/elementary_high/elementary_high_talk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:math_escape/constants/app_constants.dart';
import 'package:math_escape/models/content_item.dart';
import 'package:math_escape/widgets/school_level_card.dart';
import 'package:math_escape/widgets/content_card.dart';
import 'package:math_escape/screens/intro_screen/high_intro_screen.dart';
import '../mission/middle/middle_talk.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentPage = 0;

  final List<ContentItem> contentList = const [
    ContentItem(
      image: AppConstants.introduceImage,
      title: '부산수학문화관 소개',
      description: '저희를 소개합니다~',
      url: AppConstants.introduceUrl,
    ),
    ContentItem(
      image: AppConstants.instaLogoImage,
      title: '부산수학문화관 인스타그램',
      description: '박물관 인별에서 함께 놀아요!',
      url: AppConstants.instagramUrl,
    ),
    ContentItem(
      image: AppConstants.introduceProgramImage,
      title: '프로그램 소개',
      description: '다양한 프로그램이 있어요!',
      url: AppConstants.programUrl,
    ),
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('URL을 열 수 없습니다')),
        );
      }
    }
  }

  void _handleSchoolLevelTap(String level) {
    if (level == '고등학교') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HighIntroScreen()),
      );
    } else if (level == '초등학교 고학년') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ElementaryHighTalkScreen()),
      );
    }
    else if (level == '중학교') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MiddleIntroScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoSection(),
              const SizedBox(height: 32),
              _buildSchoolLevelsSection(),
              const SizedBox(height: 32),
              _buildHomepageSection(),
              const SizedBox(height: 32),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildSchoolLevelsSection() {
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
            onTap: () => _handleSchoolLevelTap(level),
          );
        },
      ),
    );
  }

  Widget _buildHomepageSection() {
    return GestureDetector(
      onTap: () => _launchUrl(AppConstants.homePageUrl),
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

  Widget _buildContentSection() {
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
            controller: _pageController,
            itemCount: contentList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ContentCard(
                  item: contentList[index],
                  onTap: () => _launchUrl(contentList[index].url),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        _buildPageIndicator(),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(contentList.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.blueAccent : Colors.grey[300],
          ),
        );
      }),
    );
  }
} 