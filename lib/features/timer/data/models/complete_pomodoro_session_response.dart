import 'package:json_annotation/json_annotation.dart';

import 'pomodoro_session_status.dart';

part 'complete_pomodoro_session_response.g.dart';

@JsonSerializable(createToJson: false)
class CompletePomodoroSessionResponse {
  const CompletePomodoroSessionResponse({
    required this.id,
    required this.status,
    this.endedAtUtc,
    this.taskItemId,
    this.completedPomodoroCount,
  });

  final String id;
  final PomodoroSessionStatus status;
  final DateTime? endedAtUtc;
  final String? taskItemId;
  final int? completedPomodoroCount;

  factory CompletePomodoroSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$CompletePomodoroSessionResponseFromJson(json);
}
