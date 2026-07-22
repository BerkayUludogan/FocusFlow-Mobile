import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/features/tasks/data/repositories/task_repository.dart';
import 'package:focusflow_mobile/features/timer/data/repositories/pomodoro_repository.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';

import '../cubit/timer_cubit.dart';
import '../cubit/timer_state.dart';
import '../cubit/timer_task_handoff.dart';
import '../pages/timer_page.dart';

mixin TimerViewMixin on State<TimerPage> {
  late final TimerCubit timerCubit;
  List<TaskItem> incompleteTasks = [];

  @override
  void initState() {
    super.initState();
    timerCubit = TimerCubit(
      pomodoroRepository: context.read<PomodoroRepository>(),
    )..initialize().then((_) => _consumePendingTaskHandoff());
    TimerTaskHandoff.pendingTask.addListener(_consumePendingTaskHandoff);
    loadIncompleteTasks();
  }

  // Only claim the handoff while idle — if a session is already running or
  // paused, silently drop it rather than hijacking the in-progress session
  // or applying a now-stale selection whenever it next goes idle.
  void _consumePendingTaskHandoff() {
    final task = TimerTaskHandoff.pendingTask.value;
    if (task == null || !mounted) return;
    TimerTaskHandoff.pendingTask.value = null;
    if (timerCubit.state.status == TimerStatus.idle) {
      timerCubit.selectTask(task);
    }
  }

  Future<void> loadIncompleteTasks() async {
    final response = await context.read<TaskRepository>().getTaskItems(
      pageSize: 100,
    );
    if (!mounted) return;
    setState(() {
      incompleteTasks = response.items
          .where((task) => !task.isCompleted)
          .toList();
    });
  }

  @override
  void dispose() {
    TimerTaskHandoff.pendingTask.removeListener(_consumePendingTaskHandoff);
    timerCubit.close();
    super.dispose();
  }

  Future<void> confirmCancelSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.timerCancelConfirmTitle.tr()),
        content: Text(LocaleKeys.timerCancelConfirmMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(LocaleKeys.tasksCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(LocaleKeys.timerCancel.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      timerCubit.cancelSession();
    }
  }

  Future<void> confirmFinishSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.timerFinishConfirmTitle.tr()),
        content: Text(LocaleKeys.timerFinishConfirmMessage.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(LocaleKeys.tasksCancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(LocaleKeys.timerFinish.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      timerCubit.completeNow();
    }
  }
}
