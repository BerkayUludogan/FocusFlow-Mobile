import 'package:equatable/equatable.dart';

import '../../data/models/task_item.dart';

enum TasksStatus { initial, loading, loaded, failure }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const [],
    this.errorMessage,
  });

  final TasksStatus status;
  final List<TaskItem> tasks;
  final String? errorMessage;

  bool get isLoading => status == TasksStatus.loading;

  @override
  List<Object?> get props => [status, tasks, errorMessage];
}
