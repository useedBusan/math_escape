// 사용하지 않는 파일 - HighMission이 대신 사용됨
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/base_high_view_model.dart';
import 'base_high_view.dart';
import '../../../app/theme/app_colors.dart';

/* analysis*/
//Provider 를 통한 상태괸리
//BaseView를 래핑하는 컨테이너 역할
//BaseHighViewModel() >> 모래시계 기능 포함

class HighMissionView extends StatelessWidget {
  const HighMissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BaseHighViewModel(),
      child: Builder(
        builder: (ctx) {
          final vm = ctx.read<BaseHighViewModel>();
      //BaseHighView 래핑
          //모래시계 UI가 포함된 BaseHighView 사용
          //Pane 기반 화면 전환 시스템
          //문제/해설/커스텀 3가지 화면 모드
          return BaseHighView(
            title: '역설, 혹은 모호함',
            background: Container(color: CustomBlue.s100),
            paneBuilder: (context, pane) {
              switch (pane) {
                case HighPane.problem:
                  return _ProblemPane(onShowSolution: vm.toSolution);
                case HighPane.solution:
                  return _SolutionPane(onBackToProblem: vm.toProblem);
                case HighPane.custom:
                  return const Center(child: Text('커스텀 화면'));
              }
            },
          );
        },
      ),
    );
  }
}

class _ProblemPane extends StatelessWidget {
  const _ProblemPane({required this.onShowSolution});
  final VoidCallback onShowSolution;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<BaseHighViewModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('문제 본문...', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            vm.startBody();
            onShowSolution();
          },
          child: const Text('해설 보기'),
        ),
      ],
    );
  }
}

class _SolutionPane extends StatelessWidget {
  const _SolutionPane({required this.onBackToProblem});
  final VoidCallback onBackToProblem;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<BaseHighViewModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('해설 내용...', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () {
            vm.pauseBody();
            onBackToProblem();
          },
          child: const Text('문제로 돌아가기'),
        ),
      ],
    );
  }
}
*/