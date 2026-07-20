import 'package:json_annotation/json_annotation.dart';

part 'pomodoro_settings.g.dart';

@JsonSerializable(createToJson: false)
class PomodoroSettings {
  const PomodoroSettings({
    required this.id,
    required this.focusDurationMinutes,
    required this.shortBreakDurationMinutes,
    required this.longBreakDurationMinutes,
    required this.longBreakInterval,
    required this.dailyFocusGoalMinutes,
    required this.autoStartBreaks,
    required this.autoStartPomodoros,
  });

  final String id;
  final int focusDurationMinutes;
  final int shortBreakDurationMinutes;
  final int longBreakDurationMinutes;
  final int longBreakInterval;
  final int dailyFocusGoalMinutes;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSettingsFromJson(json);
}
