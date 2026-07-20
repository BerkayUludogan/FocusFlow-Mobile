import 'package:json_annotation/json_annotation.dart';

import 'pomodoro_session_type.dart';

part 'start_pomodoro_session_request.g.dart';

@JsonSerializable(createFactory: false)
class StartPomodoroSessionRequest {
  const StartPomodoroSessionRequest({
    required this.clientId,
    this.taskItemId,
    required this.type,
  });

  final String clientId;
  final String? taskItemId;
  final PomodoroSessionType type;

  Map<String, dynamic> toJson() => _$StartPomodoroSessionRequestToJson(this);
}
