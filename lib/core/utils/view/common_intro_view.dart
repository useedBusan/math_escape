import 'package:flutter/material.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../app/theme/app_colors.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mainColor = grade?.mainColor ?? CustomPink.s500;
    final gradientColors = grade?.gradientColors ?? [CustomPink.s500.withOpacity(0.6), const Color(0x99FFFFFF)];
    final bubbleBorderColor = grade?.bubbleBorderColor ?? CustomPink.s700;
    final speakerLabelColor = grade?.speakerLabelColor ?? CustomPink.s600;

    return WillPopScope(
      onWillPop: () async {
        onBack();
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      appBarTitle,
                      style: TextStyle(
                        color: mainColor,
                        fontSize: size.width * (16 / 360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: mainColor,
                      ),
                      onPressed: onBack,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                cacheWidth: (size.width * MediaQuery.of(context).devicePixelRatio).toInt(),
                cacheHeight: (size.height * MediaQuery.of(context).devicePixelRatio).toInt(),
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
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Flexible(
                    flex: 6,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 50, // 말풍선 위 50px
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Image.asset(
                              characterImageAssetPath,
                              gaplessPlayback: true,
                              filterQuality: FilterQuality.high,
                              isAntiAlias: true,
                            ),
                          ),
                        ),
                      ],
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
                            child: Text(
                              talkText,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: size.width * (15 / 360),
                                color: Colors.black87,
                                height: 1.5,
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
                                fontSize: size.width * (16 / 360),
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
                      height: 56,
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
                            fontSize: size.width * (16 / 360),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


