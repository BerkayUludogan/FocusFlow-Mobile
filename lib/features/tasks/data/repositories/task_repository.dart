import 'package:focusflow_mobile/core/network/api_client.dart';
import 'package:focusflow_mobile/core/network/api_endpoints.dart';
import 'package:focusflow_mobile/core/network/paged_response.dart';
import 'package:focusflow_mobile/features/tasks/data/models/complete_task_item_response.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item_request.dart';

class TaskRepository {
  TaskRepository({required this._apiClient});

  final ApiClient _apiClient;

  Future<TaskItem> createTask(TaskItemRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      data: request.toJson(),
    );
    return TaskItem.fromJson(response.data!);
  }

  Future<void> updateTask(String id, TaskItemRequest request) async {
    await _apiClient.put<Map<String, dynamic>>(
      ApiEndpoints.taskById(id),
      data: request.toJson(),
    );
  }

  Future<void> deleteTask(String id) async {
    await _apiClient.delete<Map<String, dynamic>>(ApiEndpoints.taskById(id));
  }

  Future<CompleteTaskItemResponse> completeTask(String id) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.completeTask(id),
    );
    return CompleteTaskItemResponse.fromJson(response.data!);
  }

  Future<TaskItem> getTaskById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.taskById(id),
    );
    return TaskItem.fromJson(response.data!);
  }

  Future<PagedResponse<TaskItem>> getTaskItems({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.tasks,
      queryParameters: {'page': page, 'pageSize': pageSize},
    );
    return PagedResponse.fromJson(
      response.data!,
      (json) => TaskItem.fromJson(json as Map<String, dynamic>),
    );
  }
}
