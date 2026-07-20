// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_pomodoro_session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$StartPomodoroSessionRequestToJson(
  StartPomodoroSessionRequest instance,
) => <String, dynamic>{
  'clientId': instance.clientId,
  'taskItemId': instance.taskItemId,
  'type': _$PomodoroSessionTypeEnumMap[instance.type]!,
};

const _$PomodoroSessionTypeEnumMap = {
  PomodoroSessionType.focus: 1,
  PomodoroSessionType.shortBreak: 2,
  PomodoroSessionType.longBreak: 3,
};
