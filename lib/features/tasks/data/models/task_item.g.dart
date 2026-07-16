// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => TaskItem(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  isCompleted: json['isCompleted'] as bool,
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
  dueDateUtc: json['dueDateUtc'] == null
      ? null
      : DateTime.parse(json['dueDateUtc'] as String),
  estimatedPomodoroCount: (json['estimatedPomodoroCount'] as num).toInt(),
  completedPomodoroCount: (json['completedPomodoroCount'] as num).toInt(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  modifiedAtUtc: json['modifiedAtUtc'] == null
      ? null
      : DateTime.parse(json['modifiedAtUtc'] as String),
);
