import 'package:flutter/material.dart';
import 'package:focusflow_mobile/product/theme/app_colors.dart';

import '../../data/models/pomodoro_session_type.dart';
import '../extensions/pomodoro_session_type.dart';

class TimerPhaseIndicator extends StatelessWidget {
  const TimerPhaseIndicator({required this.currentType, super.key});

  final PomodoroSessionType currentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: PomodoroSessionType.values
            .map((type) => Expanded(child: _buildSegment(type)))
            .toList(),
      ),
    );
  }

  Widget _buildSegment(PomodoroSessionType type) {
    final isActive = type == currentType;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? type.color : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
