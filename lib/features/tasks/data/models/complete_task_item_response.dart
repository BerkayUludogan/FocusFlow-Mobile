import 'package:json_annotation/json_annotation.dart';

part 'complete_task_item_response.g.dart';

@JsonSerializable(createToJson: false)
class CompleteTaskItemResponse {
  const CompleteTaskItemResponse({
    required this.isCompleted,
    this.completedAtUtc,
  });

  final bool isCompleted;
  final DateTime? completedAtUtc;

  factory CompleteTaskItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CompleteTaskItemResponseFromJson(json);
}
