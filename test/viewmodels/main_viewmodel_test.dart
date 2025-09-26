// import 'package:flutter_test/flutter_test.dart';
// import 'package:math_escape/core/services/url_launcher_service.dart';
// import 'package:math_escape/core/utils/view_model/main_viewmodel.dart';
// import 'package:math_escape/core/services/navigation_service.dart';
//
// void main() {
//   group('MainViewModel Tests', () {
//     late MainViewModel viewModel;
//     late UrlLauncherService urlService;
//     late NavigationService navService;
//
//     setUp(() {
//       // 테스트용 서비스 인스턴스 생성
//       urlService = UrlLauncherService();
//       navService = NavigationService();
//
//       // MainViewModel 생성
//       viewModel = MainViewModel(urlService: urlService, navService: navService);
//     });
//
//     tearDown(() {
//       // 테스트 후 정리
//       viewModel.dispose();
//     });
//
//     test('MainViewModel 생성 테스트', () {
//       // ViewModel이 정상적으로 생성되는지 확인
//       expect(viewModel, isNotNull);
//       expect(viewModel.isLoading, false);
//       expect(viewModel.error, isNull);
//     });
//
//     test('콘텐츠 리스트 초기화 테스트', () {
//       // 콘텐츠 리스트가 정상적으로 초기화되는지 확인
//       expect(viewModel.contentList.length, 3);
//       expect(viewModel.contentList[0].title, '부산수학문화관 소개');
//       expect(viewModel.contentList[1].title, '부산수학문화관 인스타그램');
//       expect(viewModel.contentList[2].title, '프로그램 소개');
//     });
//
//     test('현재 페이지 상태 테스트', () {
//       // 초기 페이지 상태 확인
//       expect(viewModel.currentPage, 0);
//
//       // 페이지 변경 테스트
//       viewModel.onPageChanged(1);
//       expect(viewModel.currentPage, 1);
//
//       viewModel.onPageChanged(2);
//       expect(viewModel.currentPage, 2);
//     });
//
//     test('에러 상태 관리 테스트', () {
//       // 초기 에러 상태 확인
//       expect(viewModel.error, isNull);
//
//       // 에러 상태 설정 테스트
//       viewModel.setError('테스트 에러');
//       expect(viewModel.error, '테스트 에러');
//
//       // 에러 상태 초기화 테스트
//       viewModel.clearError();
//       expect(viewModel.error, isNull);
//     });
//
//     test('로딩 상태 관리 테스트', () {
//       // 초기 로딩 상태 확인
//       expect(viewModel.isLoading, false);
//
//       // 로딩 상태 설정 테스트
//       viewModel.setLoading(true);
//       expect(viewModel.isLoading, true);
//
//       viewModel.setLoading(false);
//       expect(viewModel.isLoading, false);
//     });
//
//     test('PageController 테스트', () {
//       // PageController가 정상적으로 생성되는지 확인
//       expect(viewModel.pageController, isNotNull);
//       expect(viewModel.pageController.viewportFraction, 1.0);
//     });
//   });
// }
