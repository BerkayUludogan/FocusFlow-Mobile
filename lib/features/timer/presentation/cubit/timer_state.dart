import 'package:equatable/equatable.dart';

import '../../data/models/pomodoro_session_type.dart';
import '../../data/models/pomodoro_settings.dart';

enum TimerStatus { initial, loading, idle, running, paused, failure }

class TimerState extends Equatable {
  const TimerState({
    this.status = TimerStatus.initial,
    this.settings,
    this.currentType = PomodoroSessionType.focus,
    this.sessionId,
    this.selectedTaskId,
    this.selectedTaskEstimatedCount,
    this.selectedTaskCompletedCount,
    this.remainingSeconds = 0,
    this.totalSeconds = 0,
    this.completedFocusCount = 0,
    this.errorMessage,
  });

  final TimerStatus status;
  final PomodoroSettings? settings;
  final PomodoroSessionType currentType;
  final String? sessionId;
  final String? selectedTaskId;
  final int? selectedTaskEstimatedCount;
  final int? selectedTaskCompletedCount;
  final int remainingSeconds;
  final int totalSeconds;
  final int completedFocusCount;
  final String? errorMessage;

  bool get isLoading => status == TimerStatus.loading;
  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;

  TimerState copyWith({
    TimerStatus? status,
    PomodoroSettings? settings,
    PomodoroSessionType? currentType,
    String? sessionId,
    String? selectedTaskId,
    int? selectedTaskEstimatedCount,
    int? selectedTaskCompletedCount,
    int? remainingSeconds,
    int? totalSeconds,
    int? completedFocusCount,
    String? errorMessage,
  }) {
    return TimerState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      currentType: currentType ?? this.currentType,
      sessionId: sessionId ?? this.sessionId,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
      selectedTaskEstimatedCount:
          selectedTaskEstimatedCount ?? this.selectedTaskEstimatedCount,
      selectedTaskCompletedCount:
          selectedTaskCompletedCount ?? this.selectedTaskCompletedCount,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      completedFocusCount: completedFocusCount ?? this.completedFocusCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    settings,
    currentType,
    sessionId,
    selectedTaskId,
    selectedTaskEstimatedCount,
    selectedTaskCompletedCount,
    remainingSeconds,
    totalSeconds,
    completedFocusCount,
    errorMessage,
  ];
}
