// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pomodoro_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PomodoroSession _$PomodoroSessionFromJson(Map<String, dynamic> json) =>
    PomodoroSession(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      taskItemId: json['taskItemId'] as String?,
      taskTitle: json['taskTitle'] as String?,
      type: $enumDecode(_$PomodoroSessionTypeEnumMap, json['type']),
      status: $enumDecodeNullable(
        _$PomodoroSessionStatusEnumMap,
        json['status'],
      ),
      startedAtUtc: DateTime.parse(json['startedAtUtc'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
    );

const _$PomodoroSessionTypeEnumMap = {
  PomodoroSessionType.focus: 1,
  PomodoroSessionType.shortBreak: 2,
  PomodoroSessionType.longBreak: 3,
};

const _$PomodoroSessionStatusEnumMap = {
  PomodoroSessionStatus.running: 1,
  PomodoroSessionStatus.completed: 2,
  PomodoroSessionStatus.cancelled: 3,
};
