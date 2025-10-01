import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../feature/elementary_high/model/elementary_high_intro_talk.dart';
import '../../../constants/enum/grade_enums.dart';
import '../../../constants/enum/image_enums.dart';
import 'elementary_high_mission.dart';
import '../../../core/utils/view/common_intro_view.dart';

//intro page
class PuriImage extends StatefulWidget {
  final String imagePath;
  final Key imageKey;

  const PuriImage({required this.imagePath, required this.imageKey, super.key});

  @override
  State<PuriImage> createState() => _PuriImageState();
}

class _PuriImageState extends State<PuriImage> {
  late Future<Uint8List> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = _loadImageBytes();
  }

  Future<Uint8List> _loadImageBytes() async {
    final byteData = await rootBundle.load(widget.imagePath);
    return byteData.buffer.asUint8List();
  }

  @override
  void didUpdateWidget(covariant PuriImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageKey != widget.imageKey ||
        oldWidget.imagePath != widget.imagePath) {
      _imageBytes = _loadImageBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(height: MediaQuery.of(context).size.height * 0.24);
        }
        return Image.memory(
          snapshot.data!,
          key: widget.imageKey,
          height: MediaQuery.of(context).size.height * 0.24,
        );
      },
    );
  }
}

class ElementaryHighTalkScreen extends StatefulWidget {
  const ElementaryHighTalkScreen({super.key});

  @override
  State<ElementaryHighTalkScreen> createState() =>
      _ElementaryHighTalkScreenState();
}

class _ElementaryHighTalkScreenState extends State<ElementaryHighTalkScreen>
    with WidgetsBindingObserver {
  // 앱 생명주기 이벤트를 감지하기 위한 인터페이스
  List<IntroTalkItem> talkList = [];
  int currentIndex = 0;
  bool isLoading = true;

  Key imageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadTalks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        imageKey = UniqueKey();
      });
    }
  }

  Future<void> loadTalks() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/elem_high/elem_high_intro.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      talkList = jsonList
          .map((e) => IntroTalkItem.fromJson(e))
          .toList(); //asset내의 json파일 읽어옴
      isLoading = false;
    });
  }

  void goToNext() {
    final int lastIndex = talkList.length - 1;
    if (currentIndex < lastIndex) {
      setState(() {
        currentIndex++;
        imageKey = UniqueKey();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ElementaryHighMissionScreen()),
      );
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        imageKey = UniqueKey();
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final talk = talkList[currentIndex];

    return CommonIntroView(
      appBarTitle: '미션! 수사모의 수학 보물을 찾아서',
      backgroundAssetPath: ImageAssets.background.path,
      characterImageAssetPath: talk.furiImage,
      speakerName: '푸리',
      talkText: talk.talk,
      buttonText: talk.answer,
      grade: StudentGrade.elementaryHigh,
      // 첫 번째 화면에만 furiAppearance 애니메이션 표시 (한 번만 재생)
      lottieAnimationPath: currentIndex == 0 ? 'assets/animations/furiAppearance.json' : null,
      showLottieInsteadOfImage: currentIndex == 0,
      lottieRepeat: false, // furiAppearance는 한 번만 재생
      onNext: goToNext,
      onBack: () {
        if (currentIndex > 0) {
          goToPrevious();
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
