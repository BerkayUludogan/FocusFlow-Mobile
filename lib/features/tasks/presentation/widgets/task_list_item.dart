import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
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
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: task.isCompleted ? null : (_) => onToggleComplete(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted
              ? AppColors.textSecondary
              : AppColors.textPrimary,
        ),
      ),
      subtitle: task.description != null && task.description!.isNotEmpty
          ? Text(task.description!)
          : null,
      onTap: onEdit,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}
