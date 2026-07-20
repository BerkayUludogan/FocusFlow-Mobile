// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_pomodoro_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletePomodoroSessionResponse _$CompletePomodoroSessionResponseFromJson(
  Map<String, dynamic> json,
) => CompletePomodoroSessionResponse(
  id: json['id'] as String,
  status: $enumDecode(_$PomodoroSessionStatusEnumMap, json['status']),
  endedAtUtc: json['endedAtUtc'] == null
      ? null
      : DateTime.parse(json['endedAtUtc'] as String),
  taskItemId: json['taskItemId'] as String?,
  completedPomodoroCount: (json['completedPomodoroCount'] as num?)?.toInt(),
);

const _$PomodoroSessionStatusEnumMap = {
  PomodoroSessionStatus.running: 1,
  PomodoroSessionStatus.completed: 2,
  PomodoroSessionStatus.cancelled: 3,
};
