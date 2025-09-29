import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../view_model/elementary_high_mission_view_model.dart';
import '../../../core/utils/view/qr_scan_screen.dart';
import '../../../core/services/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class ElementaryHighMissionListView extends StatelessWidget {
  const ElementaryHighMissionListView({super.key});

  void _handleQRScanResult(ElementaryHighMissionViewModel vm, String qrResult) {
    // QR 스캔 결과가 정답인지 확인
    final correctQRAnswer = serviceLocator.qrAnswerService
        .getCorrectAnswerByGrade('elementary_high', vm.currentMission!.id);
    final isCorrect = correctQRAnswer != null && qrResult == correctQRAnswer;
    
    print('초등학교 고학년 QR 스캔 결과: $qrResult');
    print('정답: $correctQRAnswer, 맞음: $isCorrect');
    
    if (isCorrect) {
      // 정답 처리 - 다음 문제로 이동
      vm.nextMission();
    } else {
      // 오답 처리 - 오답 팝업 표시 (구현 예정)
      print('오답입니다. 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ElementaryHighMissionViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!vm.hasMission) {
      return const Center(child: Text('불러올 미션이 없습니다.'));
    }

    final mission = vm.currentMission!;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: vm.progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffD95276)),
            ),
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '문제 ${vm.currentIndex + 1}',
                  style: TextStyle(
                    fontFamily: 'SBAggroM',
                    fontSize: width * (18 / 360),
                    color: AppColors.head,
                  ),
                ),
                TextSpan(
                  text: ' / ${vm.totalCount}',
                  style: TextStyle(
                    fontFamily: 'SBAggroM',
                    fontSize: width * (15 / 360),
                    color: CustomGray.darkGray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mission.question,
            textAlign: TextAlign.justify,
            style: TextStyle(
              height: 1.4,
              fontSize: width * (16 / 360),
              color: const Color(0xff333333),
            ),
          ),
          // QR 문제가 아닐 때만 텍스트 입력 표시
          if (!mission.isqr) ...[
            const SizedBox(height: 16),
            // 텍스트 입력 (elemhigh 고유 입력)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: const Color(0xffdcdcdc)),
              ),
              child: TextField(
                controller: vm.textController,
                onChanged: vm.setTypedAnswer,
                style: TextStyle(
                  fontSize: width * (15 / 360),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: '정답을 입력해 주세요.',
                  hintStyle: TextStyle(
                    fontSize: width * (14 / 360),
                    color: const Color(0xffaaaaaa),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: Color(0xffaaaaaa)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(color: Color(0xffD95276), width: 2.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (mission.questionImage != null) ...[
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.asset(
                        mission.questionImage!,
                        fit: BoxFit.contain,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          // QR 문제가 아닐 때만 보기 선택 버튼 표시
          if (!mission.isqr) ...[
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 60,
              ),
              itemCount: mission.choices.length,
              itemBuilder: (context, i) {
                final selected = vm.selectedChoiceIndex == i;
                return _ChoiceChipBox(
                  label: mission.choices[i],
                  selected: selected,
                  enabled: !vm.isBusy,
                  onTap: () => vm.selectChoice(i),
                );
              },
            ),
          ] else ...[
            // QR 문제일 때 QR 스캔 버튼 표시
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_scanner),
                label: Text(
                  'QR코드 스캔',
                  style: TextStyle(
                    fontSize: width * (16 / 360),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  final status = await Permission.camera.request();
                  if (status.isGranted) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QRScanScreen(),
                      ),
                    );
                    if (result != null && result is String) {
                      _handleQRScanResult(vm, result);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('카메라 권한이 필요합니다.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD95276),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChipBox extends StatelessWidget {
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const _ChoiceChipBox({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFFFF2) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xffD95276) : const Color(0xFFDCDCDC),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: null,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: MediaQuery.of(context).size.width * (16 / 360),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}


