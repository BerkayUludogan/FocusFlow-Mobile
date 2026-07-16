import 'package:json_annotation/json_annotation.dart';

part 'task_item_request.g.dart';

@JsonSerializable(createFactory: false)
class TaskItemRequest {
  const TaskItemRequest({
    required this.clientId,
    required this.title,
    this.description,
    this.dueDateUtc,
    required this.estimatedPomodoroCount,
  });

  final String clientId;
  final String title;
  final String? description;
  final DateTime? dueDateUtc;
  final int estimatedPomodoroCount;

  Map<String, dynamic> toJson() => _$TaskItemRequestToJson(this);
}
