import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';
import '../../../Core/services/navigation_service.dart';
import '../../../Core/services/url_launcher_service.dart';
import '../../../Core/utils/Model/content_item.dart';
import 'base_viewmodel.dart';

/// 메인 화면의 비즈니스 로직을 담당하는 ViewModel
class MainViewModel extends BaseViewModel {
  final UrlLauncherService _urlService;
  final NavigationService _navService;

  /// 콘텐츠 리스트
  List<ContentItem> _contentList = [];
  List<ContentItem> get contentList => _contentList;

  /// 현재 페이지 인덱스 (PageView용)
  int _currentPage = 0;
  int get currentPage => _currentPage;

  /// PageController (View에서 사용)
  final PageController pageController = PageController(viewportFraction: 1.0);

  MainViewModel({
    required UrlLauncherService urlService,
    required NavigationService navService,
  }) : _urlService = urlService,
       _navService = navService {
    _initializeContentList();
  }

  /// 콘텐츠 리스트 초기화
  void _initializeContentList() {
    _contentList = const [
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
  }

  /// URL 실행
  ///
  /// [url] 실행할 URL
  Future<void> launchUrl(String url) async {
    setLoading(true);
    clearError();

    try {
      final success = await _urlService.launchUrl(url);
      if (!success) {
        setError('URL을 열 수 없습니다');
      }
    } catch (e) {
      setError('URL 실행 중 오류가 발생했습니다: $e');
    } finally {
      setLoading(false);
    }
  }

  /// 학년별 미션 화면으로 이동
  ///
  /// [context] BuildContext
  /// [level] 학년 레벨
  void navigateToMission(BuildContext context, String level) {
    try {
      _navService.navigateToMission(context, level);
    } catch (e) {
      setError('화면 이동 중 오류가 발생했습니다: $e');
    }
  }

  /// 홈페이지 URL 실행
  Future<void> launchHomepage() async {
    await launchUrl(AppConstants.homePageUrl);
  }

  /// PageView 페이지 변경 처리
  ///
  /// [index] 새로운 페이지 인덱스
  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  /// 콘텐츠 카드 클릭 처리
  ///
  /// [contentItem] 클릭된 콘텐츠 아이템
  Future<void> onContentCardTap(ContentItem contentItem) async {
    await launchUrl(contentItem.url);
  }

  /// 학년별 카드 클릭 처리
  ///
  /// [context] BuildContext
  /// [level] 선택된 학년 레벨
  void onSchoolLevelCardTap(BuildContext context, String level) {
    navigateToMission(context, level);
  }

  /// 에러 상태 초기화
  void clearErrorState() {
    clearError();
  }

  /// ViewModel 정리
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
