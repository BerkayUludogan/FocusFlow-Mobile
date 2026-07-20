import 'package:json_annotation/json_annotation.dart';

import 'pomodoro_session_status.dart';

part 'cancel_pomodoro_session_response.g.dart';

@JsonSerializable(createToJson: false)
class CancelPomodoroSessionResponse {
  const CancelPomodoroSessionResponse({
    required this.id,
    required this.status,
    this.endedAtUtc,
  });

  final String id;
  final PomodoroSessionStatus status;
  final DateTime? endedAtUtc;

  factory CancelPomodoroSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelPomodoroSessionResponseFromJson(json);
}
