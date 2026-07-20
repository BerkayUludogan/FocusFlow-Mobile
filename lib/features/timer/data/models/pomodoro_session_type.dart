import 'package:json_annotation/json_annotation.dart';

enum PomodoroSessionType {
  @JsonValue(1)
  focus,
  @JsonValue(2)
  shortBreak,
  @JsonValue(3)
  longBreak,
}
