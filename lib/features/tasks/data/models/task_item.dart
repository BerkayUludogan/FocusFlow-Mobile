import 'package:json_annotation/json_annotation.dart';

part 'task_item.g.dart';

@JsonSerializable(createToJson: false)
class TaskItem {
  const TaskItem({
    required this.id,
    required this.clientId,
    required this.title,
    this.description,
    required this.isCompleted,
    this.completedAtUtc,
    this.dueDateUtc,
    required this.estimatedPomodoroCount,
    required this.completedPomodoroCount,
    required this.createdAtUtc,
    this.modifiedAtUtc,
  });

  final String id;
  final String clientId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime? completedAtUtc;
  final DateTime? dueDateUtc;
  final int estimatedPomodoroCount;
  final int completedPomodoroCount;
  final DateTime createdAtUtc;
  final DateTime? modifiedAtUtc;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  TaskItem copyWith({bool? isCompleted, DateTime? completedAtUtc}) {
    return TaskItem(
      id: id,
      clientId: clientId,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAtUtc: completedAtUtc ?? this.completedAtUtc,
      dueDateUtc: dueDateUtc,
      estimatedPomodoroCount: estimatedPomodoroCount,
      completedPomodoroCount: completedPomodoroCount,
      createdAtUtc: createdAtUtc,
      modifiedAtUtc: modifiedAtUtc,
    );
  }
}
