import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_escape/core/theme/app_colors.dart';
import 'package:math_escape/core/theme/app_dimensions.dart';

/// Truth3Card 위젯 테스트
///
/// 이 테스트는 진리 3 페이지의 카드 위젯이 올바르게 렌더링되는지 확인합니다.
class Truth3Card extends StatelessWidget {
  final String title;
  final String explanation;
  final String imagePath;

  const Truth3Card({
    super.key,
    required this.title,
    required this.explanation,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowBlack,
            blurRadius: AppDimensions.shadowBlurRadius,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * AppDimensions.fontSizeTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Text(
            explanation,
            style: TextStyle(
              fontSize: screenWidth * AppDimensions.fontSizeLarge,
              color: AppColors.textQuaternary,
              height: AppDimensions.lineHeightExtraLarge,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          Center(
            child: Image.asset(
              imagePath,
              width: screenWidth * 0.6,
              height: screenWidth * 0.4,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('Truth3Card Widget Tests', () {
    testWidgets('Truth3Card가 올바른 색상 토큰을 사용하는지 테스트', (
      WidgetTester tester,
    ) async {
      // Given
      const testTitle = '진리_3';
      const testExplanation = '측지선은 평면 또는 곡면에서 두 점을 연결하는 최단 거리를 의미한다.';
      const testImagePath = 'assets/images/high/high3.png';

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Truth3Card(
              title: testTitle,
              explanation: testExplanation,
              imagePath: testImagePath,
            ),
          ),
        ),
      );

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      // 색상 토큰 검증
      expect(decoration.color, equals(AppColors.cardWhite));
      expect(
        decoration.borderRadius,
        equals(BorderRadius.circular(AppDimensions.radiusMedium)),
      );

      // 그림자 검증
      expect(decoration.boxShadow?.length, equals(1));
      final shadow = decoration.boxShadow!.first;
      expect(shadow.color, equals(AppColors.shadowBlack));
      expect(shadow.blurRadius, equals(AppDimensions.shadowBlurRadius));
      expect(
        shadow.offset,
        equals(const Offset(0, AppDimensions.shadowOffsetY)),
      );
    });

    testWidgets('Truth3Card가 올바른 텍스트를 표시하는지 테스트', (WidgetTester tester) async {
      // Given
      const testTitle = '진리_3';
      const testExplanation = '측지선은 평면 또는 곡면에서 두 점을 연결하는 최단 거리를 의미한다.';
      const testImagePath = 'assets/images/high/high3.png';

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Truth3Card(
              title: testTitle,
              explanation: testExplanation,
              imagePath: testImagePath,
            ),
          ),
        ),
      );

      // Then
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testExplanation), findsOneWidget);
    });

    testWidgets('Truth3Card가 올바른 이미지를 표시하는지 테스트', (WidgetTester tester) async {
      // Given
      const testTitle = '진리_3';
      const testExplanation = '측지선은 평면 또는 곡면에서 두 점을 연결하는 최단 거리를 의미한다.';
      const testImagePath = 'assets/images/high/high3.png';

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Truth3Card(
              title: testTitle,
              explanation: testExplanation,
              imagePath: testImagePath,
            ),
          ),
        ),
      );

      // Then
      final imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.image, isA<AssetImage>());

      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, equals(testImagePath));
    });

    testWidgets('Truth3Card가 올바른 패딩을 사용하는지 테스트', (WidgetTester tester) async {
      // Given
      const testTitle = '진리_3';
      const testExplanation = '측지선은 평면 또는 곡면에서 두 점을 연결하는 최단 거리를 의미한다.';
      const testImagePath = 'assets/images/high/high3.png';

      // When
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Truth3Card(
              title: testTitle,
              explanation: testExplanation,
              imagePath: testImagePath,
            ),
          ),
        ),
      );

      // Then
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(
        container.padding,
        equals(const EdgeInsets.all(AppDimensions.paddingLarge)),
      );
    });
  });
}
