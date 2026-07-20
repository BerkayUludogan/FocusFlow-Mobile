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
import '../widgets/timer_page_frame.dart';
import '../widgets/timer_page_skeleton.dart';
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
            final navBarInset = max(
              MediaQuery.of(context).padding.bottom,
              12.0,
            );
            final bottomClearance =
                WidgetSizes.bottomNavBarHeight + navBarInset;

            if (state.status == TimerStatus.initial || state.isLoading) {
              return TimerPageSkeleton(
                currentType: state.currentType,
                bottomClearance: bottomClearance,
              );
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

            return TimerPageFrame(
              currentType: state.currentType,
              bottomClearance: bottomClearance,
              phaseIndicator: TimerPhaseIndicator(currentType: state.currentType),
              taskPicker: state.currentType == PomodoroSessionType.focus
                  ? TaskPicker(
                      tasks: incompleteTasks,
                      selectedTaskId: state.selectedTaskId,
                      onChanged: timerCubit.selectTask,
                      enabled: state.status == TimerStatus.idle,
                    )
                  : null,
              dialBuilder: (dialSize) => NeonTimerDial(
                size: dialSize,
                progress: progress,
                isRunning: state.isRunning,
                isPaused: state.isPaused,
                color: state.currentType.color,
                remainingSeconds: state.remainingSeconds,
                phaseLabel: state.currentType.label,
                phaseIcon: state.currentType.icon,
                activityLabel: state.currentType.activityLabel,
              ),
              controls: TimerControls(
                state: state,
                color: state.currentType.color,
                onStart: timerCubit.start,
                onPause: timerCubit.pause,
                onResume: timerCubit.resume,
                onReset: confirmCancelSession,
                onFinish: confirmFinishSession,
              ),
            );
          },
        ),
      ),
    );
  }
}
