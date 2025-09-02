import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/middle/middle_intro_talk.dart';
import 'dart:convert';
import 'package:math_escape/mission/middle/middle_mission.dart';
import 'package:math_escape/widgets/middle_talk_popup.dart';
//intro page
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

class MiddleIntroScreen extends StatefulWidget {
  const MiddleIntroScreen({super.key});

  @override
  State<MiddleIntroScreen> createState() => _MiddleIntroScreenState();
}

class _MiddleIntroScreenState extends State<MiddleIntroScreen> with WidgetsBindingObserver {
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
    final String jsonString = await rootBundle.loadString('assets/data/middle/middle_intro.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    setState(() {
      talkList = jsonList.map((e) => IntroTalkItem.fromJson(e)).toList();
      isLoading = false;
    });
  }

  void goToNext() {
    // 현재 인덱스가 0 또는 1일 때 다음 대화로 넘어갑니다.
    if (currentIndex < 2) {
      setState(() {
        currentIndex++;
        imageKey = UniqueKey();
      });
    }
    // currentIndex가 2일 때 (즉, id 3번 대화일 때)
    else if (currentIndex == 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const MiddleTalkDialog();
            },
          ).then((_) {
            // 다이얼로그가 닫히면 인덱스를 3으로 업데이트하여 다음 대화로 넘어갑니다.
            setState(() {
              currentIndex++;
              imageKey = UniqueKey();
            });
          });
        }
      });
    }
    // currentIndex가 3 이상일 때 (즉, id 4번 이후 대화)
    else if (currentIndex >= 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MiddleMissionScreen()),
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
                  Center(
                    child: Text(
                      '수학자의 비밀 노트를 찾아라!',
                      style: TextStyle(
                        color: Color(0xff3F55A7),
                        fontSize: MediaQuery.of(context).size.width * (16 / 360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF3F55A7)),
                      onPressed: () {
                        if (currentIndex > 0) {
                          goToPrevious();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
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
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(0, 0, 0, 0.75), // 위쪽 (36%)
                      Color.fromRGBO(0, 0, 0, 0.50), // 아래쪽 (20%)
                    ],
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
                        imagePath: talk.puriImage,
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
                          height: MediaQuery.of(context).size.height * 0.32,
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xff172D7F), width: 1.5),
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              talk.talk,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * (15 / 360), color: Colors.black87, height: 1.5),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xff2B4193),
                              border: Border.all(color: const Color(0xffffffff), width: 1.5),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text(
                              '푸리',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * (16 / 360),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.play_circle, color: Color(0xFF101351), size: 32),
                            onPressed: goToNext,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
