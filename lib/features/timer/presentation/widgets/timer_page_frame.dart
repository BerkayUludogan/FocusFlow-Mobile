import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';

import '../../data/models/pomodoro_session_type.dart';
import 'timer_phase_backdrop.dart';

/// Shared geometry for [TimerPage]'s loaded content and its loading
/// skeleton. Both render through this single Stack/backdrop/Column frame
/// so the two can never drift out of alignment with each other — swapping
/// between them (e.g. once `initialize()` resolves) lands every element in
/// exactly the same place.
class TimerPageFrame extends StatelessWidget {
  const TimerPageFrame({
    required this.currentType,
    required this.bottomClearance,
    required this.phaseIndicator,
    required this.dialBuilder,
    required this.controls,
    this.taskPicker,
    this.wrapContent,
    super.key,
  });

  final PomodoroSessionType currentType;
  final double bottomClearance;
  final Widget phaseIndicator;
  final Widget? taskPicker;
  final Widget Function(double dialSize) dialBuilder;
  final Widget controls;
  final Widget Function(Widget content)? wrapContent;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        phaseIndicator,
        const SizedBox(height: WidgetSizes.timerElementSpacing),
        if (taskPicker case final picker?) ...[
          picker,
          const SizedBox(height: WidgetSizes.timerElementSpacing),
        ],
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final dialSize = min(
                constraints.maxWidth,
                constraints.maxHeight,
              ).clamp(200.0, WidgetSizes.timerCircleSize);

              return Align(
                alignment: const Alignment(0, -0.35),
                child: dialBuilder(dialSize),
              );
            },
          ),
        ),
        const SizedBox(height: WidgetSizes.timerElementSpacing),
        SizedBox(
          height: WidgetSizes.timerControlsHeight,
          child: Align(alignment: Alignment.topCenter, child: controls),
        ),
      ],
    );

    return Stack(
      children: [
        Positioned.fill(
          child: TimerPhaseBackdrop(currentType: currentType),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomClearance),
            child: wrapContent != null ? wrapContent!(content) : content,
          ),
        ),
      ],
    );
  }
}
