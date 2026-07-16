import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/task_item_request.dart';
import '../../data/repositories/task_repository.dart';
import 'tasks_state.dart';

class TasksCubit extends BaseCubit<TasksState> {
  TasksCubit({required this._taskRepository})
    : super(const TasksState());

  final TaskRepository _taskRepository;
  static const _uuid = Uuid();

  Future<void> fetchTasks() async {
    emit(const TasksState(status: TasksStatus.loading));

    try {
      final response = await _taskRepository.getTaskItems();
      emit(TasksState(status: TasksStatus.loaded, tasks: response.items));
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> createTask({
    required String title,
    String? description,
    DateTime? dueDateUtc,
    required int estimatedPomodoroCount,
  }) async {
    try {
      await _taskRepository.createTask(
        TaskItemRequest(
          clientId: _uuid.v4(),
          title: title,
          description: description,
          dueDateUtc: dueDateUtc,
          estimatedPomodoroCount: estimatedPomodoroCount,
        ),
      );
      await fetchTasks();
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> updateTask({
    required String id,
    required String clientId,
    required String title,
    String? description,
    DateTime? dueDateUtc,
    required int estimatedPomodoroCount,
  }) async {
    try {
      await _taskRepository.updateTask(
        id,
        TaskItemRequest(
          clientId: clientId,
          title: title,
          description: description,
          dueDateUtc: dueDateUtc,
          estimatedPomodoroCount: estimatedPomodoroCount,
        ),
      );
      await fetchTasks();
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _taskRepository.deleteTask(id);
      emit(
        TasksState(
          status: TasksStatus.loaded,
          tasks: state.tasks.where((task) => task.id != id).toList(),
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> completeTask(String id) async {
    try {
      final response = await _taskRepository.completeTask(id);
      emit(
        TasksState(
          status: TasksStatus.loaded,
          tasks: state.tasks
              .map(
                (task) => task.id == id
                    ? task.copyWith(
                        isCompleted: response.isCompleted,
                        completedAtUtc: response.completedAtUtc,
                      )
                    : task,
              )
              .toList(),
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }
}
