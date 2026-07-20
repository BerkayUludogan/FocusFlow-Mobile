import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

import '../../data/models/pomodoro_session_type.dart';
import '../cubit/timer_state.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({
    required this.state,
    required this.color,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
    required this.onFinish,
    super.key,
  });

  final TimerState state;
  final Color color;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case TimerStatus.idle:
        final canStart =
            state.currentType != PomodoroSessionType.focus ||
            state.selectedTaskId != null;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: canStart ? onStart : null,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(LocaleKeys.timerStart.tr()),
          ),
        );
      case TimerStatus.running:
        return _buildActionRow(
          primaryIcon: Icons.pause_rounded,
          primaryLabel: LocaleKeys.timerPause.tr(),
          onPrimary: onPause,
        );
      case TimerStatus.paused:
        return _buildActionRow(
          primaryIcon: Icons.play_arrow_rounded,
          primaryLabel: LocaleKeys.timerResume.tr(),
          onPrimary: onResume,
        );
      case TimerStatus.initial:
      case TimerStatus.loading:
      case TimerStatus.failure:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionRow({
    required IconData primaryIcon,
    required String primaryLabel,
    required VoidCallback onPrimary,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CircleAction(
          icon: Icons.refresh_rounded,
          label: LocaleKeys.timerReset.tr(),
          onTap: onReset,
          size: 52,
          color: color,
        ),
        _CircleAction(
          icon: primaryIcon,
          label: primaryLabel,
          onTap: onPrimary,
          size: 68,
          color: color,
          isPrimary: true,
        ),
        _CircleAction(
          icon: Icons.stop_rounded,
          label: LocaleKeys.timerFinish.tr(),
          onTap: onFinish,
          size: 52,
          color: color,
        ),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.size,
    required this.color,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color color;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isPrimary
                    ? color.withValues(alpha: 0.45)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: isPrimary ? 20 : 10,
                spreadRadius: isPrimary ? 2 : 0,
              ),
            ],
          ),
          child: RawMaterialButton(
            onPressed: onTap,
            shape: const CircleBorder(),
            fillColor: isPrimary ? color : AppColors.surface,
            elevation: 0,
            child: Icon(
              icon,
              size: isPrimary ? 32 : 24,
              color: isPrimary ? Colors.white : color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Labels float over the photographic TimerPhaseBackdrop, so they
        // need their own opaque backing — textSecondary alone only has
        // guaranteed contrast against AppColors.surface, not arbitrary
        // photo content (e.g. the dusk long-break background).
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
