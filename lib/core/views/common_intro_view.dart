import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../app/theme/app_colors.dart';
import 'home_alert.dart';
import 'lottie_animation_widget.dart';
import '../extensions/string_extension.dart';
import '../widgets/volume_dropdown_panel.dart';

class CommonIntroView extends StatelessWidget {
  final String appBarTitle;
  final String backgroundAssetPath;
  final String characterImageAssetPath;
  final String speakerName;
  final String talkText;
  final String buttonText;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final StudentGrade? grade; // 학년 정보 추가
  final String? lottieAnimationPath; // 로티 애니메이션 경로 추가
  final bool lottieRepeat; // 로티 애니메이션 반복 여부

  const CommonIntroView({
    super.key,
    required this.appBarTitle,
    required this.backgroundAssetPath,
    required this.characterImageAssetPath,
    required this.speakerName,
    required this.talkText,
    required this.buttonText,
    required this.onNext,
    required this.onBack,
    this.grade, // 기본값 null로 하위 호환성 유지
    this.lottieAnimationPath, // 로티 애니메이션 경로
    this.lottieRepeat = true, // 기본값 true로 하위 호환성 유지
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mainColor = grade?.mainColor ?? CustomPink.s500;
    final gradientColors =
        grade?.gradientColors ??
        [CustomPink.s500.withValues(alpha: 0.6), const Color(0x99FFFFFF)];
    final bubbleBorderColor = grade?.bubbleBorderColor ?? CustomPink.s700;
    final speakerLabelColor = grade?.speakerLabelColor ?? CustomPink.s600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          onBack();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            appBarTitle,
            style: TextStyle(
              color: mainColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: mainColor, size: 28),
            onPressed: onBack,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home, color: mainColor, size: 28),
              onPressed: () {
                HomeAlert.showAndNavigate(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundAssetPath,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                gaplessPlayback: true,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // AppBar 바로 아래, 본문 우상단 BGM 아이콘
            Positioned(
              top: 15,
              right: 15,
              child: SafeArea(
                child: Builder(
                  builder: (iconContext) {
                    return GestureDetector(
                      onTap: () {
                        final RenderBox box =
                            iconContext.findRenderObject() as RenderBox;
                        final Offset iconOffset = box.localToGlobal(
                          Offset.zero,
                        );
                        final Size iconSize = box.size;
                        final Size screenSize = MediaQuery.of(iconContext).size;

                        final double panelTop =
                            iconOffset.dy + iconSize.height + 10;
                        final double panelWidth = screenSize.width * 0.93;
                        final double panelLeft =
                            (screenSize.width - panelWidth) / 2;

                        showGeneralDialog(
                          context: iconContext,
                          barrierLabel: 'volumePanel',
                          barrierDismissible: true,
                          barrierColor: Colors.transparent,
                          transitionDuration: const Duration(milliseconds: 150),
                          pageBuilder: (context, anim1, anim2) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                  ),
                                ),
                                Positioned(
                                  top: panelTop,
                                  left: panelLeft,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      width: panelWidth,
                                      child: VolumeDropdownPanel(
                                        onClose: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        'assets/images/common/soundControlIcon.png',
                        width: 28,
                        height: 28,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                      ),
                    );
                  },
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Flexible(
                    flex: 6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final characterHeight = constraints.maxHeight * 0.6;

                        return Center(
                          child: SizedBox(
                            height: characterHeight,
                            child: lottieAnimationPath != null
                                ? LottieAnimationWidget(
                                    assetPath: lottieAnimationPath!,
                                    height: characterHeight,
                                    repeat: lottieRepeat,
                                  )
                                : Image.asset(
                                    characterImageAssetPath,
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                    isAntiAlias: true,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: size.width * 0.93,
                          height: size.height * 0.28,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: bubbleBorderColor,
                              width: 1.5,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                                children: talkText.toStyledSpans(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: speakerLabelColor,
                              border: Border.all(
                                color: const Color(0xffffffff),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text(
                              speakerName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: size.width * 0.93,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onNext,
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
