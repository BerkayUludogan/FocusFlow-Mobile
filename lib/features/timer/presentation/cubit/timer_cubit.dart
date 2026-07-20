import 'dart:async';

import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/product/state/base_cubit.dart';
import 'package:uuid/uuid.dart';

import 'package:focusflow_mobile/features/tasks/data/models/task_item.dart';

import '../../data/models/pomodoro_session_type.dart';
import '../../data/models/pomodoro_settings.dart';
import '../../data/models/start_pomodoro_session_request.dart';
import '../../data/repositories/pomodoro_repository.dart';
import 'timer_state.dart';

class TimerCubit extends BaseCubit<TimerState> {
  TimerCubit({required this._pomodoroRepository})
    : super(const TimerState());

  final PomodoroRepository _pomodoroRepository;
  static const _uuid = Uuid();
  Timer? _ticker;

  // Anchors the countdown to wall-clock time instead of a naive per-tick
  // decrement, so `Timer.periodic` jitter/backgrounding can't drift the
  // displayed remaining time away from the actual elapsed duration.
  DateTime? _segmentStartedAtUtc;
  int _elapsedBeforeSegmentSeconds = 0;

  Future<void> initialize() async {
    emit(state.copyWith(status: TimerStatus.loading));

    try {
      final settings = await _pomodoroRepository.getSettings();
      final runningResponse = await _pomodoroRepository.getRunningSession();
      final completedFocusCount = await _pomodoroRepository
          .getTodayCompletedFocusCount();

      if (runningResponse.hasRunningSession && runningResponse.session != null) {
        final session = runningResponse.session!;
        final totalSeconds = session.durationMinutes * 60;
        final elapsedSeconds = DateTime.now()
            .toUtc()
            .difference(session.startedAtUtc)
            .inSeconds;
        final remainingSeconds = (totalSeconds - elapsedSeconds).clamp(0, totalSeconds);

        emit(
          TimerState(
            status: TimerStatus.running,
            settings: settings,
            currentType: session.type,
            sessionId: session.id,
            selectedTaskId: session.taskItemId,
            remainingSeconds: remainingSeconds,
            totalSeconds: totalSeconds,
            completedFocusCount: completedFocusCount,
          ),
        );

        if (remainingSeconds > 0) {
          _elapsedBeforeSegmentSeconds = elapsedSeconds.clamp(0, totalSeconds);
          _segmentStartedAtUtc = DateTime.now().toUtc();
          _startTicker();
        } else {
          await _completeCurrentSession();
        }
        return;
      }

      final totalSeconds = _durationForType(PomodoroSessionType.focus, settings) * 60;
      emit(
        TimerState(
          status: TimerStatus.idle,
          settings: settings,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
          completedFocusCount: completedFocusCount,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: TimerStatus.failure,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  void selectTask(TaskItem task) {
    emit(
      state.copyWith(
        selectedTaskId: task.id,
        selectedTaskEstimatedCount: task.estimatedPomodoroCount,
        selectedTaskCompletedCount: task.completedPomodoroCount,
      ),
    );
  }

  Future<void> start() async {
    if (state.currentType == PomodoroSessionType.focus && state.selectedTaskId == null) {
      return;
    }

    try {
      final session = await _pomodoroRepository.startSession(
        StartPomodoroSessionRequest(
          clientId: _uuid.v4(),
          taskItemId: state.currentType == PomodoroSessionType.focus
              ? state.selectedTaskId
              : null,
          type: state.currentType,
        ),
      );

      final totalSeconds = session.durationMinutes * 60;
      emit(
        state.copyWith(
          status: TimerStatus.running,
          sessionId: session.id,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
        ),
      );
      _elapsedBeforeSegmentSeconds = 0;
      _segmentStartedAtUtc = DateTime.now().toUtc();
      _startTicker();
    } catch (error) {
      emit(
        state.copyWith(
          status: TimerStatus.failure,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  void pause() {
    if (!state.isRunning) return;
    _ticker?.cancel();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void resume() {
    if (!state.isPaused) return;
    emit(state.copyWith(status: TimerStatus.running));
    _elapsedBeforeSegmentSeconds = state.totalSeconds - state.remainingSeconds;
    _segmentStartedAtUtc = DateTime.now().toUtc();
    _startTicker();
  }

  Future<void> cancelSession() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    _ticker?.cancel();

    try {
      await _pomodoroRepository.cancelSession(sessionId);
      final totalSeconds = _durationForType(state.currentType, state.settings) * 60;
      emit(
        TimerState(
          status: TimerStatus.idle,
          settings: state.settings,
          currentType: state.currentType,
          selectedTaskId: state.selectedTaskId,
          selectedTaskEstimatedCount: state.selectedTaskEstimatedCount,
          selectedTaskCompletedCount: state.selectedTaskCompletedCount,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
          completedFocusCount: state.completedFocusCount,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: TimerStatus.failure,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  Future<void> completeNow() async {
    if (state.sessionId == null) return;
    _ticker?.cancel();
    await _completeCurrentSession();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!state.isRunning) return;

    final elapsedInSegment = DateTime.now()
        .toUtc()
        .difference(_segmentStartedAtUtc!)
        .inSeconds;
    final totalElapsed = _elapsedBeforeSegmentSeconds + elapsedInSegment;
    final next = (state.totalSeconds - totalElapsed).clamp(0, state.totalSeconds);

    if (next <= 0) {
      _ticker?.cancel();
      emit(state.copyWith(remainingSeconds: 0));
      _completeCurrentSession();
    } else if (next != state.remainingSeconds) {
      emit(state.copyWith(remainingSeconds: next));
    }
  }

  Future<void> _completeCurrentSession() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    try {
      final response = await _pomodoroRepository.completeSession(sessionId);

      final wasFocus = state.currentType == PomodoroSessionType.focus;
      final completedFocusCount = wasFocus
          ? state.completedFocusCount + 1
          : state.completedFocusCount;
      final nextType = _nextType(wasFocus, completedFocusCount, state.settings);
      final totalSeconds = _durationForType(nextType, state.settings) * 60;
      final shouldAutoStart = wasFocus
          ? (state.settings?.autoStartBreaks ?? false)
          : (state.settings?.autoStartPomodoros ?? false);
      final selectedTaskCompletedCount = wasFocus
          ? (response.completedPomodoroCount ?? state.selectedTaskCompletedCount)
          : state.selectedTaskCompletedCount;

      emit(
        TimerState(
          status: TimerStatus.idle,
          settings: state.settings,
          currentType: nextType,
          selectedTaskId: state.selectedTaskId,
          selectedTaskEstimatedCount: state.selectedTaskEstimatedCount,
          selectedTaskCompletedCount: selectedTaskCompletedCount,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
          completedFocusCount: completedFocusCount,
        ),
      );

      final canAutoStart =
          nextType != PomodoroSessionType.focus || state.selectedTaskId != null;
      if (shouldAutoStart && canAutoStart) {
        await start();
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: TimerStatus.failure,
          errorMessage: error is ApiException ? error.toString() : null,
        ),
      );
    }
  }

  PomodoroSessionType _nextType(
    bool wasFocus,
    int completedFocusCount,
    PomodoroSettings? settings,
  ) {
    if (!wasFocus) return PomodoroSessionType.focus;
    final interval = settings?.longBreakInterval ?? 4;
    return completedFocusCount % interval == 0
        ? PomodoroSessionType.longBreak
        : PomodoroSessionType.shortBreak;
  }

  int _durationForType(PomodoroSessionType type, PomodoroSettings? settings) {
    switch (type) {
      case PomodoroSessionType.focus:
        return settings?.focusDurationMinutes ?? 25;
      case PomodoroSessionType.shortBreak:
        return settings?.shortBreakDurationMinutes ?? 5;
      case PomodoroSessionType.longBreak:
        return settings?.longBreakDurationMinutes ?? 15;
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
