import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/features/tasks/presentation/widgets/task_list_skeleton.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../mixins/tasks_view_mixin.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_list_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TasksViewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tasksCubit,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showTaskFormSheet(context, cubit: tasksCubit),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {

            if (state.isLoading) {
              return const TaskListSkeleton();
            }
            if (state.status == TasksStatus.failure && state.tasks.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage ?? LocaleKeys.tasksLoadFailed.tr(),
                ),
              );
            }

            if (state.tasks.isEmpty) {
              return Center(child: Text(LocaleKeys.tasksEmpty.tr()));
            }

            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return TaskListItem(
                  task: task,
                  onToggleComplete: () => confirmComplete(task.id),
                  onEdit: () => showTaskFormSheet(
                    context,
                    cubit: tasksCubit,
                    existingTask: task,
                  ),
                  onDelete: () => confirmDelete(task.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
