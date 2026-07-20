import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../product/constants/project_radius.dart';
import '../../../../product/constants/widget_sizes.dart';
import '../../../../product/theme/app_colors.dart';
import '../../data/models/pomodoro_session_type.dart';
import 'timer_page_frame.dart';

class TimerPageSkeleton extends StatelessWidget {
  const TimerPageSkeleton({
    required this.currentType,
    required this.bottomClearance,
    super.key,
  });

  final PomodoroSessionType currentType;
  final double bottomClearance;

  @override
  Widget build(BuildContext context) {
    return TimerPageFrame(
      currentType: currentType,
      bottomClearance: bottomClearance,
      phaseIndicator: const _SkeletonBox(height: 48, radius: 30),
      taskPicker: currentType == PomodoroSessionType.focus
          ? const _SkeletonBox(height: 64, radius: 20)
          : null,
      dialBuilder: (size) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
      // A fresh session always resolves to TimerStatus.idle, which renders
      // a single full-width "Start" button (see TimerControls) — not the
      // 3-button reset/pause/finish row, which only appears once a session
      // is actually running or paused.
      controls: const _SkeletonBox(
        height: WidgetSizes.buttonHeight,
        radius: ProjectRadius.small,
      ),
      // Wraps every placeholder piece in a single Shimmer instance so the
      // sweep stays in sync across the phase bar, task picker, dial, and
      // controls — the photo backdrop behind them is left untouched.
      wrapContent: (content) => Shimmer.fromColors(
        baseColor: AppColors.primaryLight,
        highlightColor: AppColors.surface,
        child: content,
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
