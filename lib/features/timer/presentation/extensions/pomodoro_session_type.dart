import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

import '../../data/models/pomodoro_session_type.dart';

extension PomodoroSessionTypeX on PomodoroSessionType {
  String get label {
    switch (this) {
      case PomodoroSessionType.focus:
        return LocaleKeys.timerFocusLabel.tr();
      case PomodoroSessionType.shortBreak:
        return LocaleKeys.timerShortBreakLabel.tr();
      case PomodoroSessionType.longBreak:
        return LocaleKeys.timerLongBreakLabel.tr();
    }
  }

  Color get color {
    switch (this) {
      case PomodoroSessionType.focus:
        return AppColors.primary;
      case PomodoroSessionType.shortBreak:
        return AppColors.shortBreak;
      case PomodoroSessionType.longBreak:
        return AppColors.longBreak;
    }
  }

  IconData get icon {
    switch (this) {
      case PomodoroSessionType.focus:
        return Icons.eco_outlined;
      case PomodoroSessionType.shortBreak:
        return Icons.local_cafe_outlined;
      case PomodoroSessionType.longBreak:
        return Icons.self_improvement;
    }
  }

  String get activityLabel {
    switch (this) {
      case PomodoroSessionType.focus:
        return LocaleKeys.timerActivityFocusLabel.tr();
      case PomodoroSessionType.shortBreak:
        return LocaleKeys.timerActivityShortBreakLabel.tr();
      case PomodoroSessionType.longBreak:
        return LocaleKeys.timerActivityLongBreakLabel.tr();
    }
  }
}
