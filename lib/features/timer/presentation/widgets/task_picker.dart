import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

class TaskPicker extends StatelessWidget {
  const TaskPicker({
    required this.tasks,
    required this.selectedTaskId,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final List<TaskItem> tasks;
  final String? selectedTaskId;
  final ValueChanged<TaskItem> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10),
          ],
        ),
        child: Text(
          LocaleKeys.timerNoTasks.tr(),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTaskId,
          isExpanded: true,
          itemHeight: 56,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          hint: _TaskRow(
            icon: Icons.folder_outlined,
            label: LocaleKeys.timerSelectTask.tr(),
          ),
          selectedItemBuilder: (context) {
            return tasks
                .map(
                  (task) => _TaskRow(
                    icon: Icons.folder_outlined,
                    label: task.title,
                    caption: LocaleKeys.timerSelectedTaskLabel.tr(),
                  ),
                )
                .toList();
          },
          items: tasks
              .map(
                (task) =>
                    DropdownMenuItem(value: task.id, child: Text(task.title)),
              )
              .toList(),
          onChanged: enabled
              ? (id) {
                  if (id == null) return;
                  onChanged(tasks.firstWhere((task) => task.id == id));
                }
              : null,
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.icon, required this.label, this.caption});

  final IconData icon;
  final String label;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (caption != null)
                  Text(
                    caption!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
