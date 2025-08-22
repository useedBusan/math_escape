import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'elementary_high_mission.dart';
import '../../models/elementary_high/elementary_high_intro_talk.dart';

class PuriImage extends StatefulWidget {
  final String imagePath;
  final Key imageKey;

  const PuriImage({
    required this.imagePath,
    required this.imageKey,
    super.key,
  });

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
    if (oldWidget.imageKey != widget.imageKey || oldWidget.imagePath != widget.imagePath) {
      _imageBytes = _loadImageBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(height: 240);
        }
        return Image.memory(
          snapshot.data!,
          key: widget.imageKey,
          height: 240,
        );
      },
    );
  }
}

class ElementaryHighTalkScreen extends StatefulWidget {
  const ElementaryHighTalkScreen({super.key});

  @override
  State<ElementaryHighTalkScreen> createState() => _ElementaryHighTalkScreenState();
}

class _ElementaryHighTalkScreenState extends State<ElementaryHighTalkScreen> with WidgetsBindingObserver {
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
    final String jsonString = await rootBundle.loadString('lib/data/elementary_high/elementary_high_intro.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      talkList = jsonList.map((e) => IntroTalkItem.fromJson(e)).toList();
      isLoading = false;
    });
  }

  void goToNext() {
    if (currentIndex < 3) { // id 1, 2, 3번 대화까지만 다음 대화로
      setState(() {
        currentIndex++;
        imageKey = UniqueKey();
      });
    } else if (currentIndex == 3) { // id 4번 대화에서 문제 화면으로
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final talk = talkList[currentIndex];

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex > 0) {
          goToPrevious();
          return false;
        }
        return true;
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
                  const Center(
                    child: Text(
                      '미션! 수사모의 수학 유산을 찾아서',
                      style: TextStyle(
                        color: Color(0xffD95276),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xffD95276)),
                      onPressed: () => Navigator.of(context).pop(),
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
                'assets/images/bsbackground.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x99D95276),
                      Color(0x99FFFFFF),
                    ],
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
                    child: Center(
                      child: PuriImage(
                        imagePath: talk.puri_image,
                        imageKey: imageKey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.93,
                          height: 220,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xff952B47), width: 1.5),
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              talk.talk,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xffB73D5D),
                              border: Border.all(color: const Color(0xffffffff), width: 1.5),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Text(
                              '푸리',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                      width: MediaQuery.of(context).size.width * 0.93,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD95276),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: goToNext,
                        child: Text(
                          talk.answer,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
