import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';
import 'package:focusflow_mobile/product/utils/task_meta_formatter.dart';

// Above this, a task shows so many planned sessions that per-session dots
// would just add visual noise — the "X/Y tamamlandı" text alone still
// carries the information.
const _maxProgressDots = 8;

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    required this.task,
    required this.focusDurationMinutes,
    required this.isFavorite,
    required this.onToggleComplete,
    required this.onToggleFavorite,
    required this.onStartFocusSession,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final TaskItem task;
  final int focusDurationMinutes;
  final bool isFavorite;
  final VoidCallback onToggleComplete;
  final VoidCallback onToggleFavorite;
  final VoidCallback onStartFocusSession;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.taskAccentColorFor(task.id);
    // dueDateUtc is stored as UTC-midnight of the *picked local calendar
    // date*, not a true UTC instant — read its y/m/d back directly instead
    // of `.toLocal()`, which would shift the date for negative-UTC-offset
    // users, and compare calendar days rather than exact instants so a task
    // isn't "overdue" for the first several hours of its own due date.
    final dueDate = task.dueDateUtc;
    final now = DateTime.now();
    final isOverdue = !task.isCompleted &&
        dueDate != null &&
        DateTime(dueDate.year, dueDate.month, dueDate.day)
            .isBefore(DateTime(now.year, now.month, now.day));
    final hasSessions = task.estimatedPomodoroCount > 0;
    final hasMeta = dueDate != null || hasSessions;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: task.isCompleted ? 0.55 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -6,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEdit,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CompleteCheckbox(
                            isCompleted: task.isCompleted,
                            onTap: task.isCompleted ? null : onToggleComplete,
                          ),
                          const SizedBox(width: 4),
                          _TaskAvatar(color: accent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
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
                                if (hasMeta) ...[
                                  const SizedBox(height: 6),
                                  _TaskMetaRow(
                                    dueDate: dueDate,
                                    isOverdue: isOverdue,
                                    hasSessions: hasSessions,
                                    estimatedCount: task.estimatedPomodoroCount,
                                    focusDurationMinutes: focusDurationMinutes,
                                    accent: accent,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          _FavoriteButton(
                            isFavorite: isFavorite,
                            onTap: onToggleFavorite,
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
                    if (hasSessions) ...[
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0x11000000),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
                        child: Row(
                          children: [
                            if (task.estimatedPomodoroCount <=
                                _maxProgressDots) ...[
                              _ProgressDots(
                                completed: task.completedPomodoroCount,
                                total: task.estimatedPomodoroCount,
                                color: accent,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              LocaleKeys.tasksCompletedSessions.tr(
                                args: [
                                  task.completedPomodoroCount.toString(),
                                  task.estimatedPomodoroCount.toString(),
                                ],
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            if (!task.isCompleted)
                              _StartSessionButton(
                                color: accent,
                                onTap: onStartFocusSession,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _TaskAction { edit, delete }

class _TaskMetaRow extends StatelessWidget {
  const _TaskMetaRow({
    required this.dueDate,
    required this.isOverdue,
    required this.hasSessions,
    required this.estimatedCount,
    required this.focusDurationMinutes,
    required this.accent,
  });

  final DateTime? dueDate;
  final bool isOverdue;
  final bool hasSessions;
  final int estimatedCount;
  final int focusDurationMinutes;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    // A due date takes over the whole meta line; only in its absence do we
    // fall back to session count + total planned duration.
    if (dueDate != null) {
      return _MetaChip(
        leading: const Text('📅', style: TextStyle(fontSize: 11)),
        label: formatTaskDueDate(dueDate!),
        color: isOverdue ? AppColors.error : AppColors.textSecondary,
        background: isOverdue
            ? AppColors.error.withValues(alpha: 0.1)
            : AppColors.primaryLight,
      );
    }

    if (!hasSessions) return const SizedBox.shrink();

    final totalMinutes = estimatedCount * focusDurationMinutes;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MetaChip(
          leading: const Text('🍅', style: TextStyle(fontSize: 11)),
          label: LocaleKeys.tasksSessionCount.tr(
            args: [estimatedCount.toString()],
          ),
          color: AppColors.textSecondary,
          background: accent.withValues(alpha: 0.12),
        ),
        const SizedBox(width: 6),
        _MetaChip(
          leading: const Text('🕐', style: TextStyle(fontSize: 11)),
          label: formatSessionDuration(totalMinutes),
          color: AppColors.textSecondary,
          background: AppColors.primaryLight,
        ),
      ],
    );
  }
}

class _CompleteCheckbox extends StatelessWidget {
  const _CompleteCheckbox({required this.isCompleted, required this.onTap});

  final bool isCompleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Hit area is padded out to ~40x40 (Fitts's Law / touch-target
    // guidance) without inflating the visual checkbox size.
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: isCompleted
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.4),
                width: 1.6,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                : null,
          ),
        ),
      ),
    );
  }
}

class _TaskAvatar extends StatelessWidget {
  const _TaskAvatar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.description_rounded, size: 18, color: color),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
        color: isFavorite ? AppColors.favorite : AppColors.textSecondary,
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({
    required this.completed,
    required this.total,
    required this.color,
  });

  final int completed;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final isFilled = index < completed;
        return Padding(
          padding: EdgeInsets.only(right: index == total - 1 ? 0 : 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? color : color.withValues(alpha: 0.2),
            ),
          ),
        );
      }),
    );
  }
}

class _StartSessionButton extends StatelessWidget {
  const _StartSessionButton({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_arrow_rounded, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  LocaleKeys.tasksStartSession.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
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

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.leading,
    required this.label,
    required this.color,
    required this.background,
  });

  final Widget leading;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
