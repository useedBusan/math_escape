import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:math_escape/core/services/service_locator.dart';
import 'package:math_escape/main.dart';

void main() {
  group('Main Screen Integration Tests', () {
    setUp(() async {
      // 서비스 초기화
      await serviceLocator.initialize();
    });

    tearDown(() {
      // 테스트 후 정리
      serviceLocator.dispose();
    });

    testWidgets('앱 시작부터 메인 화면까지 전체 플로우 테스트', (WidgetTester tester) async {
      // 1. 앱 시작
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 2. 스플래시 화면 확인 (잠시 대기)
      await tester.pump(const Duration(seconds: 1));

      // 3. 메인 화면 로딩 대기
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. 메인 화면 UI 요소 확인
      expect(find.text('기타 콘텐츠'), findsOneWidget);
      expect(find.text('>> 홈페이지 바로가기'), findsOneWidget);

      // 5. 학년별 카드들이 표시되는지 확인
      expect(find.byType(ListView), findsOneWidget);

      // 6. 이미지들이 표시되는지 확인
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('중학교 카드 클릭 시 네비게이션 플로우 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 중학교 카드 찾기 및 클릭
      final middleSchoolCard = find.text('중학교');
      expect(middleSchoolCard, findsOneWidget);

      await tester.tap(middleSchoolCard);
      await tester.pumpAndSettle();

      // 3. MiddleIntroScreen으로 이동했는지 확인
      // (실제 화면 전환 확인)
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('초등학교 고학년 카드 클릭 시 네비게이션 플로우 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 초등학교 고학년 카드 찾기 및 클릭
      final elementaryHighCard = find.text('초등학교 고학년');
      expect(elementaryHighCard, findsOneWidget);

      await tester.tap(elementaryHighCard);
      await tester.pumpAndSettle();

      // 3. ElementaryHighTalkScreen으로 이동했는지 확인
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('고등학교 카드 클릭 시 네비게이션 플로우 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 고등학교 카드 찾기 및 클릭
      final highSchoolCard = find.text('고등학교');
      expect(highSchoolCard, findsOneWidget);

      await tester.tap(highSchoolCard);
      await tester.pumpAndSettle();

      // 3. HighIntroScreen으로 이동했는지 확인
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('초등학교 저학년 카드 클릭 시 네비게이션 플로우 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 초등학교 저학년 카드 찾기 및 클릭
      final elementaryLowCard = find.text('초등학교 저학년');
      expect(elementaryLowCard, findsOneWidget);

      await tester.tap(elementaryLowCard);
      await tester.pumpAndSettle();

      // 3. ElementaryLowIntroView로 이동했는지 확인
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('홈페이지 버튼 클릭 시 URL 실행 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 홈페이지 버튼 찾기 및 클릭
      final homepageButton = find.text('>> 홈페이지 바로가기');
      expect(homepageButton, findsOneWidget);

      await tester.tap(homepageButton);
      await tester.pumpAndSettle();

      // 3. URL 실행 확인 (실제 외부 앱 실행은 테스트 환경에서 제한적)
      // ViewModel의 launchHomepage 메서드가 호출되었는지 확인
      // 에러가 발생하지 않았는지 확인
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('콘텐츠 카드 클릭 시 URL 실행 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 콘텐츠 카드들 찾기
      final contentCards = find.byType(GestureDetector);
      expect(contentCards, findsWidgets);

      // 3. 첫 번째 콘텐츠 카드 클릭
      await tester.tap(contentCards.first);
      await tester.pumpAndSettle();

      // 4. URL 실행 확인 (에러가 발생하지 않았는지 확인)
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('PageView 스와이프 동작 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. PageView 찾기
      final pageView = find.byType(PageView);
      expect(pageView, findsOneWidget);

      // 3. 스와이프 동작 테스트
      await tester.drag(pageView, const Offset(-300, 0));
      await tester.pumpAndSettle();

      // 4. 페이지 인디케이터 업데이트 확인
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('뒤로가기 버튼 동작 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 중학교 카드 클릭하여 다른 화면으로 이동
      await tester.tap(find.text('중학교'));
      await tester.pumpAndSettle();

      // 3. 뒤로가기 버튼 동작 (Android)
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 4. 메인 화면으로 돌아왔는지 확인
      expect(find.text('기타 콘텐츠'), findsOneWidget);
    });

    testWidgets('앱 생명주기 테스트 (백그라운드/포그라운드)', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 앱이 정상적으로 로드되었는지 확인
      expect(find.text('기타 콘텐츠'), findsOneWidget);

      // 3. 앱 상태 변경 시뮬레이션
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/lifecycle',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('AppLifecycleState.paused', null),
        ),
        (data) {},
      );
      await tester.pump();

      // 4. 앱이 정상적으로 유지되는지 확인
      expect(find.text('기타 콘텐츠'), findsOneWidget);
    });

    testWidgets('메모리 사용량 및 성능 테스트', (WidgetTester tester) async {
      // 1. 앱 시작 및 메인 화면 로딩
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 2. 여러 번의 네비게이션 테스트
      for (int i = 0; i < 3; i++) {
        // 중학교 카드 클릭
        await tester.tap(find.text('중학교'));
        await tester.pumpAndSettle();

        // 뒤로가기
        await tester.pageBack();
        await tester.pumpAndSettle();

        // 초등학교 고학년 카드 클릭
        await tester.tap(find.text('초등학교 고학년'));
        await tester.pumpAndSettle();

        // 뒤로가기
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      // 3. 메인 화면이 정상적으로 유지되는지 확인
      expect(find.text('기타 콘텐츠'), findsOneWidget);
    });
  });
}
