// 사용하지 않는 파일 - BaseHighView가 대신 사용됨
/*
import 'package:flutter/material.dart';

// 고등학교 미션 전용 위젯들

class HighMissionCard extends StatelessWidget {
  final Widget child;
  final double screenWidth;
  final double screenHeight;

  const HighMissionCard({
    super.key,
    required this.child,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // 첫번째 레이어 (어두운 배경)
        Container(
          width: screenWidth - 60,
          height: screenHeight * 0.5,
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF192243),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF192243), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        // 두번째 레이어 (파란색 중간)
        Container(
          width: screenWidth - 40,
          height: screenHeight * 0.5,
          margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF3F55A7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF192243), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        // 세번째 레이어 (흰색 콘텐츠)
        Container(
          width: screenWidth - 20,
          height: screenHeight * 0.5,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF192243), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}

class HighHintCard extends StatelessWidget {
  final String hintTitle;
  final String hintContent;
  final bool isVisible;
  final double screenWidth;

  const HighHintCard({
    super.key,
    required this.hintTitle,
    required this.hintContent,
    required this.isVisible,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: isVisible ? const Duration(milliseconds: 300) : Duration.zero,
      curve: Curves.easeOut,
      offset: isVisible ? Offset.zero : const Offset(0, 0.1),
      child: AnimatedOpacity(
        duration: isVisible ? const Duration(milliseconds: 300) : Duration.zero,
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * (16 / 360)),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                hintTitle,
                style: TextStyle(
                  fontSize: screenWidth * (14 / 360),
                  fontFamily: "SBAggroM",
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF101351),
                ),
              ),
              SizedBox(height: screenWidth * (8 / 360)),
              Text(
                hintContent,
                style: TextStyle(
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * (13 / 360),
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HighHintButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double screenWidth;

  const HighHintButton({
    super.key,
    required this.onPressed,
    required this.screenWidth,
  });

  @override
  State<HighHintButton> createState() => _HighHintButtonState();
}

class _HighHintButtonState extends State<HighHintButton>
    with TickerProviderStateMixin {
  late AnimationController _hintColorController;
  late Animation<double> _hintColorAnimation;

  @override
  void initState() {
    super.initState();
    _hintColorController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _hintColorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hintColorController, curve: Curves.easeInOut),
    );

    _hintColorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hintColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _hintColorAnimation,
          builder: (context, child) {
            final color = Color.lerp(
              const Color(0xFF3F55A7),
              const Color(0xFFB2BBDC),
              _hintColorAnimation.value,
            )!;
            return IconButton(
              icon: Icon(Icons.help_outline, color: color),
              onPressed: widget.onPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              iconSize: 28,
            );
          },
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _hintColorAnimation,
          builder: (context, child) {
            final color = Color.lerp(
              const Color(0xFF3F55A7),
              const Color(0xFFB2BBDC),
              _hintColorAnimation.value,
            )!;
            return Transform.translate(
              offset: const Offset(0, -15),
              child: Text(
                '힌트',
                style: TextStyle(
                  color: color,
                  fontSize: widget.screenWidth * (12 / 360),
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class HighAnswerInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final double screenWidth;
  final Color mainColor;

  const HighAnswerInput({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.screenWidth,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xffdcdcdc)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              style: TextStyle(fontSize: screenWidth * (15 / 360)),
              controller: controller,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: '정답을 입력해 주세요.',
                hintStyle: TextStyle(
                  fontSize: screenWidth * (14 / 360),
                  color: const Color(0xffaaaaaa),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            height: 52,
            child: ElevatedButton(
              onPressed: onSubmitted,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  fontSize: screenWidth * (14 / 360),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
