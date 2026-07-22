import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

enum TaskFilterOption { all, today, upcoming, completed }

extension TaskFilterOptionX on TaskFilterOption {
  String get label {
    switch (this) {
      case TaskFilterOption.all:
        return LocaleKeys.tasksFilterAll.tr();
      case TaskFilterOption.today:
        return LocaleKeys.tasksFilterToday.tr();
      case TaskFilterOption.upcoming:
        return LocaleKeys.tasksFilterUpcoming.tr();
      case TaskFilterOption.completed:
        return LocaleKeys.tasksFilterCompleted.tr();
    }
  }

  /// [today] must already be a local, time-stripped date (midnight).
  bool matches(TaskItem task, DateTime today) {
    switch (this) {
      case TaskFilterOption.all:
        return true;
      case TaskFilterOption.completed:
        return task.isCompleted;
      case TaskFilterOption.today:
      case TaskFilterOption.upcoming:
        if (task.isCompleted) return false;
        // dueDateUtc is stored as UTC-midnight of the *picked local calendar
        // date* (see task_form_sheet's _pickDueDate), not a true UTC instant
        // — so read its y/m/d back directly instead of `.toLocal()`, which
        // would shift the date for negative-UTC-offset users.
        final due = task.dueDateUtc;
        if (due == null) return false;
        final dueDate = DateTime(due.year, due.month, due.day);
        return this == TaskFilterOption.today
            ? dueDate.isAtSameMomentAs(today)
            : dueDate.isAfter(today);
    }
  }
}

class TaskFilterTabs extends StatelessWidget {
  const TaskFilterTabs({
    required this.tasks,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<TaskItem> tasks;
  final TaskFilterOption selected;
  final ValueChanged<TaskFilterOption> onSelected;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TaskFilterOption.values.map((option) {
          final count = tasks
              .where((task) => option.matches(task, today))
              .length;
          final isSelected = option == selected;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _FilterPill(
              label: option.label,
              count: count,
              isSelected: isSelected,
              onTap: () => onSelected(option),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
