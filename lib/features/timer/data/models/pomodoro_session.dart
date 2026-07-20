import 'package:json_annotation/json_annotation.dart';

import 'pomodoro_session_status.dart';
import 'pomodoro_session_type.dart';

part 'pomodoro_session.g.dart';

@JsonSerializable(createToJson: false)
class PomodoroSession {
  const PomodoroSession({
    required this.id,
    required this.clientId,
    this.taskItemId,
    this.taskTitle,
    required this.type,
    this.status,
    required this.startedAtUtc,
    required this.durationMinutes,
  });

  final String id;
  final String clientId;
  final String? taskItemId;
  final String? taskTitle;
  final PomodoroSessionType type;
  final PomodoroSessionStatus? status;
  final DateTime startedAtUtc;
  final int durationMinutes;

  factory PomodoroSession.fromJson(Map<String, dynamic> json) =>
      _$PomodoroSessionFromJson(json);
}
