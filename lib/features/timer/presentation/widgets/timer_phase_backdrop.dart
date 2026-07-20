import 'package:flutter/material.dart';

import '../../data/models/pomodoro_session_type.dart';

class TimerPhaseBackdrop extends StatelessWidget {
  const TimerPhaseBackdrop({required this.currentType, super.key});

  final PomodoroSessionType currentType;

  static const _assetsByType = {
    PomodoroSessionType.focus: 'assets/images/timer/focus_bg.png',
    PomodoroSessionType.shortBreak: 'assets/images/timer/short_break_bg.png',
    PomodoroSessionType.longBreak: 'assets/images/timer/long_break_bg.png',
  };

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Image.asset(
        _assetsByType[currentType]!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
