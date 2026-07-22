import 'package:equatable/equatable.dart';

import '../../data/models/task_item.dart';

enum TasksStatus { initial, loading, loaded, failure }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.errorMessage,
    this.focusDurationMinutes = 25,
    this.favoriteTaskIds = const {},
  });

  final TasksStatus status;
  final List<TaskItem> tasks;
  final String? errorMessage;

  // Falls back to the backend's own default (see TimerCubit._durationForType)
  // until the real pomodoro settings finish loading.
  final int focusDurationMinutes;

  // UI-only "favorite" toggle — there's no backend field for it, so it
  // lives purely in this cubit's memory and resets on app relaunch.
  final Set<String> favoriteTaskIds;

  bool get isLoading => status == TasksStatus.loading;

  @override
  List<Object?> get props => [
    status,
    tasks,
    errorMessage,
    focusDurationMinutes,
    favoriteTaskIds,
  ];
}
