import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../data/models/pomodoro_session_type.dart';
import '../cubit/timer_cubit.dart';
import '../cubit/timer_state.dart';
import '../extensions/pomodoro_session_type.dart';
import '../mixins/timer_view_mixin.dart';
import '../widgets/neon_timer_dial.dart';
import '../widgets/task_picker.dart';
import '../widgets/timer_controls.dart';
import '../widgets/timer_phase_backdrop.dart';
import '../widgets/timer_phase_indicator.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TimerViewMixin {
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('timer-page-visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          loadIncompleteTasks();
        }
      },
      child: BlocProvider.value(
        value: timerCubit,
        child: BlocBuilder<TimerCubit, TimerState>(
          builder: (context, state) {
            if (state.status == TimerStatus.initial || state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TimerStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? LocaleKeys.timerLoadFailed.tr()),
                    const SizedBox(height: WidgetSizes.sectionSpacing),
                    ElevatedButton(
                      onPressed: timerCubit.initialize,
                      child: Text(LocaleKeys.timerRetry.tr()),
                    ),
                  ],
                ),
              );
            }

            final progress = state.totalSeconds == 0
                ? 0.0
                : state.remainingSeconds / state.totalSeconds;

            final navBarInset = max(
              MediaQuery.of(context).padding.bottom,
              12.0,
            );
            final bottomClearance =
                WidgetSizes.bottomNavBarHeight + navBarInset;

            return Stack(
              children: [
                Positioned.fill(
                  child: TimerPhaseBackdrop(currentType: state.currentType),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, bottomClearance),
                    child: Column(
                      children: [
                        TimerPhaseIndicator(currentType: state.currentType),
                        const SizedBox(height: WidgetSizes.timerElementSpacing),
                        if (state.currentType == PomodoroSessionType.focus)
                          TaskPicker(
                            tasks: incompleteTasks,
                            selectedTaskId: state.selectedTaskId,
                            onChanged: timerCubit.selectTask,
                            enabled: state.status == TimerStatus.idle,
                          ),
                        if (state.currentType == PomodoroSessionType.focus)
                          const SizedBox(
                            height: WidgetSizes.timerElementSpacing,
                          ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final dialSize = min(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              ).clamp(200.0, WidgetSizes.timerCircleSize);

                              return Align(
                                alignment: const Alignment(0, -0.35),
                                child: NeonTimerDial(
                                  size: dialSize,
                                  progress: progress,
                                  isRunning: state.isRunning,
                                  color: state.currentType.color,
                                  remainingSeconds: state.remainingSeconds,
                                  phaseLabel: state.currentType.label,
                                  phaseIcon: state.currentType.icon,
                                  activityLabel:
                                      state.currentType.activityLabel,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: WidgetSizes.timerElementSpacing),
                        SizedBox(
                          height: WidgetSizes.timerControlsHeight,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: TimerControls(
                              state: state,
                              color: state.currentType.color,
                              onStart: timerCubit.start,
                              onPause: timerCubit.pause,
                              onResume: timerCubit.resume,
                              onReset: confirmCancelSession,
                              onFinish: confirmFinishSession,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
