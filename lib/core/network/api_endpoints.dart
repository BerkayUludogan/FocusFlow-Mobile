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
}
