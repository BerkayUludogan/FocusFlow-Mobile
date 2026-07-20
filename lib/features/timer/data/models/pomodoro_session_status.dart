import 'package:json_annotation/json_annotation.dart';

enum PomodoroSessionStatus {
  @JsonValue(1)
  running,
  @JsonValue(2)
  completed,
  @JsonValue(3)
  cancelled,
}
