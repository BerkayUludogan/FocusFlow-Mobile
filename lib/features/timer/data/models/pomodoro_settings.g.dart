// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PomodoroSettings _$PomodoroSettingsFromJson(
  Map<String, dynamic> json,
) => PomodoroSettings(
  id: json['id'] as String,
  focusDurationMinutes: (json['focusDurationMinutes'] as num).toInt(),
  shortBreakDurationMinutes: (json['shortBreakDurationMinutes'] as num).toInt(),
  longBreakDurationMinutes: (json['longBreakDurationMinutes'] as num).toInt(),
  longBreakInterval: (json['longBreakInterval'] as num).toInt(),
  dailyFocusGoalMinutes: (json['dailyFocusGoalMinutes'] as num).toInt(),
  autoStartBreaks: json['autoStartBreaks'] as bool,
  autoStartPomodoros: json['autoStartPomodoros'] as bool,
);
