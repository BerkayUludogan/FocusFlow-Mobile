// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_pomodoro_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelPomodoroSessionResponse _$CancelPomodoroSessionResponseFromJson(
  Map<String, dynamic> json,
) => CancelPomodoroSessionResponse(
  id: json['id'] as String,
  status: $enumDecode(_$PomodoroSessionStatusEnumMap, json['status']),
  endedAtUtc: json['endedAtUtc'] == null
      ? null
      : DateTime.parse(json['endedAtUtc'] as String),
);

const _$PomodoroSessionStatusEnumMap = {
  PomodoroSessionStatus.running: 1,
  PomodoroSessionStatus.completed: 2,
  PomodoroSessionStatus.cancelled: 3,
};
