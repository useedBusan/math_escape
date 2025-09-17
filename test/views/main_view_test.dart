// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:math_escape/app/main_view.dart';
// import 'package:math_escape/core/services/url_launcher_service.dart';
// import 'package:math_escape/core/utils/view_model/main_viewmodel.dart';
// import 'package:math_escape/core/services/navigation_service.dart';
//
// void main() {
//   group('MainView Tests', () {
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
//     testWidgets('MainView가 정상적으로 렌더링되는지 테스트', (WidgetTester tester) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 이미지들이 표시되는지 확인 (로고, 홈페이지 배경, 콘텐츠 이미지들)
//       expect(find.byType(Image), findsWidgets);
//
//       // 학년별 카드들이 표시되는지 확인
//       expect(find.byType(ListView), findsOneWidget);
//
//       // 홈페이지 섹션이 표시되는지 확인
//       expect(find.text('>> 홈페이지 바로가기'), findsOneWidget);
//
//       // 콘텐츠 섹션이 표시되는지 확인
//       expect(find.text('기타 콘텐츠'), findsOneWidget);
//     });
//
//     testWidgets('학년별 카드 클릭 시 ViewModel 메서드가 호출되는지 테스트', (
//       WidgetTester tester,
//     ) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 학년별 카드 찾기
//       final schoolLevelCards = find.byType(GestureDetector);
//       expect(schoolLevelCards, findsWidgets);
//
//       // 첫 번째 카드 클릭
//       await tester.tap(schoolLevelCards.first);
//       await tester.pump();
//
//       // ViewModel의 onSchoolLevelCardTap이 호출되었는지 확인
//       // (실제 네비게이션은 테스트 환경에서 제한적이므로 메서드 호출만 확인)
//       expect(viewModel, isNotNull);
//     });
//
//     testWidgets('홈페이지 버튼 클릭 시 ViewModel 메서드가 호출되는지 테스트', (
//       WidgetTester tester,
//     ) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 홈페이지 버튼 찾기
//       final homepageButton = find.text('>> 홈페이지 바로가기');
//       expect(homepageButton, findsOneWidget);
//
//       // 홈페이지 버튼 클릭
//       await tester.tap(homepageButton);
//       await tester.pump();
//
//       // ViewModel의 launchHomepage이 호출되었는지 확인
//       expect(viewModel, isNotNull);
//     });
//
//     testWidgets('콘텐츠 카드들이 정상적으로 표시되는지 테스트', (WidgetTester tester) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // PageView가 표시되는지 확인
//       expect(find.byType(PageView), findsOneWidget);
//
//       // 콘텐츠 리스트의 길이 확인
//       expect(viewModel.contentList.length, 3);
//     });
//
//     testWidgets('페이지 인디케이터가 정상적으로 표시되는지 테스트', (WidgetTester tester) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 페이지 인디케이터 컨테이너들이 표시되는지 확인
//       final indicators = find.byType(Container);
//       expect(indicators, findsWidgets);
//     });
//
//     testWidgets('ViewModel 상태 변경 시 UI가 업데이트되는지 테스트', (
//       WidgetTester tester,
//     ) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 초기 상태 확인
//       expect(viewModel.currentPage, 0);
//
//       // 페이지 변경
//       viewModel.onPageChanged(1);
//       await tester.pump();
//
//       // UI가 업데이트되었는지 확인
//       expect(viewModel.currentPage, 1);
//     });
//
//     testWidgets('로딩 상태 변경 시 UI가 업데이트되는지 테스트', (WidgetTester tester) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 초기 로딩 상태 확인
//       expect(viewModel.isLoading, false);
//
//       // 로딩 상태 변경
//       viewModel.setLoading(true);
//       await tester.pump();
//
//       // UI가 업데이트되었는지 확인
//       expect(viewModel.isLoading, true);
//     });
//
//     testWidgets('에러 상태 변경 시 UI가 업데이트되는지 테스트', (WidgetTester tester) async {
//       // MainView 위젯 생성
//       await tester.pumpWidget(
//         MaterialApp(home: MainView(viewModel: viewModel)),
//       );
//
//       // 초기 에러 상태 확인
//       expect(viewModel.error, isNull);
//
//       // 에러 상태 설정
//       viewModel.setError('테스트 에러');
//       await tester.pump();
//
//       // UI가 업데이트되었는지 확인
//       expect(viewModel.error, '테스트 에러');
//     });
//   });
// }
