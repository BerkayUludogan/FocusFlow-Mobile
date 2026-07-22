import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow_mobile/core/routing/app_routes.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/features/tasks/presentation/widgets/task_list_skeleton.dart';
import 'package:focusflow_mobile/features/timer/presentation/cubit/timer_task_handoff.dart';
import 'package:focusflow_mobile/product/constants/widget_sizes.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/tasks_cubit.dart';
import '../cubit/tasks_state.dart';
import '../mixins/tasks_view_mixin.dart';
import '../widgets/task_filter_tabs.dart';
import '../widgets/task_form_sheet.dart';
import '../widgets/task_list_item.dart';
import '../widgets/task_search_bar.dart';
import '../widgets/tasks_header.dart';

enum _TaskSortOption { createdDate, dueDate, title }

extension on _TaskSortOption {
  String get label {
    switch (this) {
      case _TaskSortOption.createdDate:
        return LocaleKeys.tasksSortByCreatedDate.tr();
      case _TaskSortOption.dueDate:
        return LocaleKeys.tasksSortByDueDate.tr();
      case _TaskSortOption.title:
        return LocaleKeys.tasksSortByTitle.tr();
    }
  }

  int compare(TaskItem a, TaskItem b) {
    switch (this) {
      case _TaskSortOption.createdDate:
        return b.createdAtUtc.compareTo(a.createdAtUtc);
      case _TaskSortOption.dueDate:
        final aDue = a.dueDateUtc;
        final bDue = b.dueDateUtc;
        if (aDue == null && bDue == null) return 0;
        if (aDue == null) return 1;
        if (bDue == null) return -1;
        return aDue.compareTo(bDue);
      case _TaskSortOption.title:
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }
  }
}

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with TasksViewMixin {
  final _searchController = TextEditingController();
  TaskFilterOption _filter = TaskFilterOption.today;
  _TaskSortOption _sort = _TaskSortOption.createdDate;
  String _query = '';

  // Snapshot of the last computed display order, keyed by task id. Ticking a
  // task complete must not yank it to the bottom mid-scroll, so we only
  // recompute ordering when the underlying task set actually changes (added,
  // removed, or a filter/sort/search change) — not on every completion toggle.
  List<String>? _orderedIds;
  TaskFilterOption? _orderedFilter;
  _TaskSortOption? _orderedSort;
  String? _orderedQuery;
  Set<String>? _orderedIdSet;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _filter = TaskFilterOption.all;
      _sort = _TaskSortOption.createdDate;
      _query = '';
      _searchController.clear();
    });
  }

  List<TaskItem> _visibleTasks(List<TaskItem> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final query = _query.trim().toLowerCase();

    final filtered = tasks
        .where((task) => _filter.matches(task, today))
        .where(
          (task) => query.isEmpty || task.title.toLowerCase().contains(query),
        )
        .toList();

    final idSet = filtered.map((task) => task.id).toSet();
    final sameIdSet =
        _orderedIdSet != null &&
        _orderedIdSet!.length == idSet.length &&
        idSet.every(_orderedIdSet!.contains);
    final needsResort =
        _orderedIds == null ||
        _orderedFilter != _filter ||
        _orderedSort != _sort ||
        _orderedQuery != query ||
        !sameIdSet;

    if (needsResort) {
      filtered.sort((a, b) {
        if (a.isCompleted != b.isCompleted) return a.isCompleted ? 1 : -1;
        return _sort.compare(a, b);
      });
      _orderedIds = filtered.map((task) => task.id).toList();
      _orderedFilter = _filter;
      _orderedSort = _sort;
      _orderedQuery = query;
      _orderedIdSet = idSet;
    } else {
      final rank = {
        for (var i = 0; i < _orderedIds!.length; i++) _orderedIds![i]: i,
      };
      filtered.sort(
        (a, b) => (rank[a.id] ?? 0).compareTo(rank[b.id] ?? 0),
      );
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: tasksCubit,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => showTaskFormSheet(context, cubit: tasksCubit),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TasksHeader(
                  onProfileTap: () => context.push(AppRoutes.settings),
                ),
                const SizedBox(height: WidgetSizes.sectionSpacing),
                Expanded(
                  child: BlocConsumer<TasksCubit, TasksState>(
                    listener: (context, state) {
                      // Surface failures even when older tasks are still on
                      // screen — otherwise a failed create/update/delete
                      // just silently leaves the list looking unchanged.
                      if (state.status == TasksStatus.failure) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                state.errorMessage ??
                                    LocaleKeys.tasksLoadFailed.tr(),
                              ),
                            ),
                          );
                      }
                    },
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const TaskListSkeleton();
                      }
                      if (state.status == TasksStatus.failure &&
                          state.tasks.isEmpty) {
                        return Center(
                          child: Text(
                            state.errorMessage ??
                                LocaleKeys.tasksLoadFailed.tr(),
                          ),
                        );
                      }
                      if (state.tasks.isEmpty) {
                        return Center(child: Text(LocaleKeys.tasksEmpty.tr()));
                      }

                      final visibleTasks = _visibleTasks(state.tasks);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TaskFilterTabs(
                            tasks: state.tasks,
                            selected: _filter,
                            onSelected: (option) =>
                                setState(() => _filter = option),
                          ),
                          const SizedBox(height: 14),
                          TaskSearchBar(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _query = value),
                            onClearFilters: _clearFilters,
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.tasksMyTasks.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              PopupMenuButton<_TaskSortOption>(
                                initialValue: _sort,
                                onSelected: (option) =>
                                    setState(() => _sort = option),
                                itemBuilder: (context) => _TaskSortOption
                                    .values
                                    .map(
                                      (option) => PopupMenuItem(
                                        value: option,
                                        child: Text(option.label),
                                      ),
                                    )
                                    .toList(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      LocaleKeys.tasksSort.tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.expand_more,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: visibleTasks.isEmpty
                                ? Center(
                                    child: Text(LocaleKeys.tasksNoResults.tr()),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(top: 4),
                                    itemCount: visibleTasks.length,
                                    itemBuilder: (context, index) {
                                      final task = visibleTasks[index];
                                      return TaskListItem(
                                        task: task,
                                        focusDurationMinutes:
                                            state.focusDurationMinutes,
                                        isFavorite: state.favoriteTaskIds
                                            .contains(task.id),
                                        onToggleComplete: () =>
                                            confirmComplete(task.id),
                                        onToggleFavorite: () =>
                                            tasksCubit.toggleFavorite(
                                              task.id,
                                            ),
                                        onStartFocusSession: () {
                                          TimerTaskHandoff.request(task);
                                          context.go(AppRoutes.timer);
                                        },
                                        onEdit: () => showTaskFormSheet(
                                          context,
                                          cubit: tasksCubit,
                                          existingTask: task,
                                        ),
                                        onDelete: () => confirmDelete(task.id),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
