import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/enum/grade_enums.dart';
import '../widgets/volume_dropdown_panel.dart';
import '../services/audio_service.dart';
import 'lottie_animation_widget.dart';
import 'home_alert.dart';
import '../extensions/string_extension.dart';
import 'package:gal/gal.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class OutroView extends StatefulWidget {
  final StudentGrade grade;
  final String lottieAssetPath;
  final String? voiceAssetPath;
  final String certificateAssetPath;
  final String title;
  final String backgroundAssetPath;
  final String speakerName;
  final String talkText;

  const OutroView({
    super.key,
    required this.grade,
    required this.title,
    required this.certificateAssetPath,
    required this.lottieAssetPath,
    required this.backgroundAssetPath,
    required this.speakerName,
    required this.talkText,
    this.voiceAssetPath,
  });

  @override
  State<OutroView> createState() => _OutroViewState();
}

class _OutroViewState extends State<OutroView> {
  final AudioService _audio = AudioService();

  @override
  void initState() {
    super.initState();
    if (widget.voiceAssetPath != null && widget.voiceAssetPath!.isNotEmpty) {
      _audio.playCharacterAudio(widget.voiceAssetPath!);
    }
  }

  @override
  void dispose() {
    _audio.stopCharacter();
    super.dispose();
  }

  Future<void> _saveCertificate() async {
    if (!mounted) return;

    try {
      // 에셋 로드
      final ByteData data = await rootBundle.load(widget.certificateAssetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      if (Platform.isAndroid) {
        // 안드로이드: image_gallery_saver_plus 사용
        final result = await ImageGallerySaverPlus.saveImage(bytes);
        if (!mounted) return;
        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('수료증이 갤러리에 저장되었습니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('저장 실패: ${result['errorMessage'] ?? '알 수 없는 오류'}')),
          );
        }
      } else {
        // iOS: Gal 패키지 사용
        if (!await Gal.hasAccess()) {
          await Gal.requestAccess();
          if (!await Gal.hasAccess()) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('권한이 거부되어 저장할 수 없습니다.')),
            );
            return;
          }
        }

        final String ext = 'webp';
        final String name = 'certificate_${DateTime.now().millisecondsSinceEpoch}.$ext';
        await Gal.putImageBytes(bytes, name: name, album: 'Math_Escape');

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수료증이 갤러리에 저장되었습니다.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: $e')),
      );
    }
  }

  void _showVolumePanel(BuildContext iconContext) {
    final RenderBox? box = iconContext.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset iconOffset = box.localToGlobal(Offset.zero);
    final Size iconSize = box.size;
    final Size screenSize = MediaQuery.of(iconContext).size;

    final double panelTop = iconOffset.dy + iconSize.height + 10;
    final double panelWidth = screenSize.width * 0.93;
    final double panelLeft = (screenSize.width - panelWidth) / 2;

    showGeneralDialog(
      context: iconContext,
      barrierLabel: 'volumePanel',
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, a1, a2) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(onTap: () => Navigator.of(context).pop()),
            ),
            Positioned(
              top: panelTop,
              left: panelLeft,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: panelWidth,
                  child: VolumeDropdownPanel(
                    onClose: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final mainColor = widget.grade.mainColor;
    final gradientColors = widget.grade.gradientColors;
    final bubbleBorderColor = widget.grade.bubbleBorderColor;
    final speakerLabelColor = widget.grade.speakerLabelColor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            widget.title,
            style: TextStyle(
              color: mainColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: mainColor, size: 28),
            onPressed: () => Navigator.of(context).pop(),
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
                widget.backgroundAssetPath,
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
            Positioned(
              top: 15,
              right: 15,
              child: SafeArea(
                child: Builder(
                  builder: (iconContext) {
                    return GestureDetector(
                      onTap: () => _showVolumePanel(iconContext),
                      child: Image.asset(
                        'assets/images/common/soundControlIcon.webp',
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
                        final lottieHeight = constraints.maxHeight * 0.6;

                        return Center(
                          child: SizedBox(
                            height: lottieHeight,
                            child: LottieAnimationWidget(
                              assetPath: widget.lottieAssetPath,
                              height: lottieHeight,
                              repeat: true,
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
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                                children: widget.talkText.toStyledSpans(fontSize: 18),
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
                              widget.speakerName,
                              style: const TextStyle(
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
                        onPressed: _saveCertificate,
                        child: const Text(
                          '수료증 다운로드',
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