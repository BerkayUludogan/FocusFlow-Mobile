import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/features/timer/data/repositories/pomodoro_repository.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/task_item_request.dart';
import '../../data/repositories/task_repository.dart';
import 'tasks_state.dart';

class TasksCubit extends BaseCubit<TasksState> {
  TasksCubit({
    required this._taskRepository,
    required this._pomodoroRepository,
  }) : super(const TasksState());

  final TaskRepository _taskRepository;
  final PomodoroRepository _pomodoroRepository;
  static const _uuid = Uuid();

  Future<void> fetchTasks() async {
    emit(
      TasksState(
        status: TasksStatus.loading,
        focusDurationMinutes: state.focusDurationMinutes,
        favoriteTaskIds: state.favoriteTaskIds,
      ),
    );

    try {
      final response = await _taskRepository.getTaskItems();
      // Settings are a nice-to-have for the duration display, not worth
      // failing the whole task list over — keep whatever we last had.
      final focusDurationMinutes = await _pomodoroRepository
          .getSettings()
          .then((settings) => settings.focusDurationMinutes)
          .catchError((_) => state.focusDurationMinutes);

      emit(
        TasksState(
          status: TasksStatus.loaded,
          tasks: response.items,
          focusDurationMinutes: focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  // Re-fetches tasks without the intermediate loading state — used after
  // create/update so the list doesn't flash a full skeleton over an already
  // visible task list. The initial load and pull-to-refresh use fetchTasks()
  // instead, where showing the skeleton is the correct behavior.
  Future<void> _refreshTasksSilently() async {
    try {
      final response = await _taskRepository.getTaskItems();
      emit(
        TasksState(
          status: TasksStatus.loaded,
          tasks: response.items,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  void toggleFavorite(String id) {
    final favorites = Set<String>.from(state.favoriteTaskIds);
    if (!favorites.remove(id)) favorites.add(id);
    emit(
      TasksState(
        status: state.status,
        tasks: state.tasks,
        focusDurationMinutes: state.focusDurationMinutes,
        favoriteTaskIds: favorites,
      ),
    );
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
      await _refreshTasksSilently();
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
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
      await _refreshTasksSilently();
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
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
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
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
                        completedAtUtc: () => response.completedAtUtc,
                      )
                    : task,
              )
              .toList(),
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
        ),
      );
    } catch (error) {
      emit(
        TasksState(
          status: TasksStatus.failure,
          tasks: state.tasks,
          focusDurationMinutes: state.focusDurationMinutes,
          favoriteTaskIds: state.favoriteTaskIds,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }
}
