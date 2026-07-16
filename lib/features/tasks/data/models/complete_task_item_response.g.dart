// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_task_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompleteTaskItemResponse _$CompleteTaskItemResponseFromJson(
  Map<String, dynamic> json,
) => CompleteTaskItemResponse(
  isCompleted: json['isCompleted'] as bool,
  completedAtUtc: json['completedAtUtc'] == null
      ? null
      : DateTime.parse(json['completedAtUtc'] as String),
);
