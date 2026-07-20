import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final TaskItem task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                _CompleteCheckbox(
                  isCompleted: task.isCompleted,
                  onTap: task.isCompleted ? null : onToggleComplete,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.taskAccentColorFor(task.id),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (task.isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 22,
                  )
                else
                  // TODO: wire up to a real favorite/priority field once
                  // the API supports one — purely decorative for now.
                  const Icon(
                    Icons.star_border_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                PopupMenuButton<_TaskAction>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                  ),
                  onSelected: (action) => switch (action) {
                    _TaskAction.edit => onEdit(),
                    _TaskAction.delete => onDelete(),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _TaskAction.edit,
                      child: Text(LocaleKeys.tasksEditTask.tr()),
                    ),
                    PopupMenuItem(
                      value: _TaskAction.delete,
                      child: Text(LocaleKeys.tasksDelete.tr()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _TaskAction { edit, delete }

class _CompleteCheckbox extends StatelessWidget {
  const _CompleteCheckbox({required this.isCompleted, required this.onTap});

  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isCompleted
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 14)
            : null,
      ),
    );
  }
}
