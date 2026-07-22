import 'package:flutter/foundation.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';

/// Bridges a "Devam Et" tap on a task card (Tasks tab) to [TimerCubit],
/// which lives inside TimerPage's own State and isn't otherwise reachable
/// from another tab: StatefulShellRoute keeps each branch's widget subtree
/// (and its cubit) alive independently, so there's no ambient way to call
/// `TimerCubit.selectTask` across tabs without either this notifier or
/// promoting TimerCubit to a global singleton.
class TimerTaskHandoff {
  const TimerTaskHandoff._();

  static final ValueNotifier<TaskItem?> pendingTask = ValueNotifier(null);

  static void request(TaskItem task) => pendingTask.value = task;
}
