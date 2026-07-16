// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$TaskItemRequestToJson(TaskItemRequest instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'title': instance.title,
      'description': instance.description,
      'dueDateUtc': instance.dueDateUtc?.toIso8601String(),
      'estimatedPomodoroCount': instance.estimatedPomodoroCount,
    };
