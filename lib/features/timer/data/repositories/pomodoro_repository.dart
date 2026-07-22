import 'package:focusflow_mobile/core/network/api_client.dart';
import 'package:focusflow_mobile/core/network/api_endpoints.dart';
import 'package:focusflow_mobile/features/timer/data/models/cancel_pomodoro_session_response.dart';
import 'package:focusflow_mobile/features/timer/data/models/complete_pomodoro_session_response.dart';
import 'package:focusflow_mobile/features/timer/data/models/pomodoro_session.dart';
import 'package:focusflow_mobile/features/timer/data/models/pomodoro_settings.dart';
import 'package:focusflow_mobile/features/timer/data/models/running_pomodoro_session_response.dart';
import 'package:focusflow_mobile/features/timer/data/models/start_pomodoro_session_request.dart';

class PomodoroRepository {
  PomodoroRepository({required this._apiClient});

  final ApiClient _apiClient;

  Future<PomodoroSession> startSession(
    StartPomodoroSessionRequest request,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSessionsStart,
      data: request.toJson(),
    );
    return PomodoroSession.fromJson(response.data!);
  }

  Future<CompletePomodoroSessionResponse> completeSession(String id) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSessionComplete(id),
    );
    return CompletePomodoroSessionResponse.fromJson(response.data!);
  }

  Future<CancelPomodoroSessionResponse> cancelSession(String id) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSessionCancel(id),
    );
    return CancelPomodoroSessionResponse.fromJson(response.data!);
  }

  Future<RunningPomodoroSessionResponse> getRunningSession() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSessionsRunning,
    );
    return RunningPomodoroSessionResponse.fromJson(response.data!);
  }

  Future<PomodoroSettings> getSettings() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSettings,
    );
    return PomodoroSettings.fromJson(response.data!);
  }

  Future<int> getTodayCompletedFocusCount() async {
    final now = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(now.year, now.month, now.day);
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.pomodoroSessions,
      queryParameters: {
        'type': 1, // Focus
        'status': 2, // Completed
        'fromUtc': startOfDay.toIso8601String(),
        'pageSize': 1,
      },
    );
    return (response.data!['totalCount'] as num).toInt();
  }
}