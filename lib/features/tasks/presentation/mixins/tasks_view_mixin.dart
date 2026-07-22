import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/tasks/data/repositories/task_repository.dart';
import 'package:focusflow_mobile/features/timer/data/repositories/pomodoro_repository.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

import '../cubit/tasks_cubit.dart';
import '../pages/tasks_page.dart';

mixin TasksViewMixin on State<TasksPage> {
  late final TasksCubit tasksCubit;

  @override
  void initState() {
    super.initState();
    tasksCubit = TasksCubit(
      taskRepository: context.read<TaskRepository>(),
      pomodoroRepository: context.read<PomodoroRepository>(),
    )..fetchTasks();
  }

  @override
  void dispose() {
    tasksCubit.close();
    super.dispose();
  }

  Future<void> confirmComplete(String id) => _confirmAction(
    title: LocaleKeys.tasksCompleteConfirmTitle.tr(),
    message: LocaleKeys.tasksCompleteConfirmMessage.tr(),
    confirmLabel: LocaleKeys.tasksComplete.tr(),
    onConfirm: () => tasksCubit.completeTask(id),
  );

  Future<void> confirmDelete(String id) => _confirmAction(
    title: LocaleKeys.tasksDeleteConfirmTitle.tr(),
    message: LocaleKeys.tasksDeleteConfirmMessage.tr(),
    confirmLabel: LocaleKeys.tasksDelete.tr(),
    onConfirm: () => tasksCubit.deleteTask(id),
  );

  Future<void> _confirmAction({
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(LocaleKeys.tasksCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirm();
    }
  }
}