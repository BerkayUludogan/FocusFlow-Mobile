// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running_pomodoro_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunningPomodoroSessionResponse _$RunningPomodoroSessionResponseFromJson(
  Map<String, dynamic> json,
) => RunningPomodoroSessionResponse(
  hasRunningSession: json['hasRunningSession'] as bool,
  session: json['session'] == null
      ? null
      : PomodoroSession.fromJson(json['session'] as Map<String, dynamic>),
);
