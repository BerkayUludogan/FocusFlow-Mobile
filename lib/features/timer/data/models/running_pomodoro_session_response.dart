import 'package:json_annotation/json_annotation.dart';

import 'pomodoro_session.dart';

part 'running_pomodoro_session_response.g.dart';

@JsonSerializable(createToJson: false)
class RunningPomodoroSessionResponse {
  const RunningPomodoroSessionResponse({
    required this.hasRunningSession,
    this.session,
  });

  final bool hasRunningSession;
  final PomodoroSession? session;

  factory RunningPomodoroSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$RunningPomodoroSessionResponseFromJson(json);
}
