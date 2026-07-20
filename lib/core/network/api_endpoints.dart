class ApiEndpoints {
  const ApiEndpoints._();

  static const String register = "/api/auth/register";
  static const String login = "/api/auth/login";
  static const String refreshToken = "/api/auth/refresh-token";
  static const String logout = "/api/auth/logout";
  static const String me = "/api/auth/me";

  static const String verifyEmail = "/api/auth/verify-email";
  static const String resendVerificationCode =
      "/api/auth/resend-email-verification-code";

  static const String forgotPassword = "/api/auth/forgot-password";
  static const String resetPassword = "/api/auth/reset-password";

  static const String tasks = "/api/tasks";
  static const String pomodoroSessionsStart = "/api/pomodoro-sessions/start";
  static const String pomodoroSettings = "/api/users/me/pomodoro-settings";

  static String taskById(String id) => "/api/tasks/$id";
  static String completeTask(String id) => "/api/tasks/$id/complete";

  static const String pomodoroSessions = "/api/pomodoro-sessions";
  static const String pomodoroSessionsRunning =
      "/api/pomodoro-sessions/running";
  static String pomodoroSessionComplete(String id) =>
      "/api/pomodoro-sessions/$id/complete";
  static String pomodoroSessionCancel(String id) =>
      "/api/pomodoro-sessions/$id/cancel";
}
