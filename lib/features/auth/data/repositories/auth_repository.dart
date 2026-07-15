import 'package:easy_localization/easy_localization.dart';
import 'package:focusflow_mobile/core/network/api_client.dart';
import 'package:focusflow_mobile/core/network/api_endpoints.dart';
import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/core/storage/token_storage.dart';
import 'package:focusflow_mobile/features/auth/data/models/login_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/login_response.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';
import 'package:focusflow_mobile/features/auth/data/models/register_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/register_response.dart';
import 'package:focusflow_mobile/features/auth/data/models/verify_email_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/resend_verification_code_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/success_response.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository({required this._apiClient, required this._tokenStorage});

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    final data = response.data;

    if (data == null) {
      throw ApiException(message: LocaleKeys.authEmptyResponse.tr());
    }

    final loginResponse = LoginResponse.fromJson(data);

    await _tokenStorage.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    return loginResponse;
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw ApiException(message: LocaleKeys.authEmptyResponse.tr());
    }
    return RegisterResponse.fromJson(data);
  }

  Future<bool> verifyEmail(VerifyEmailRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.verifyEmail,
      data: request.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw ApiException(message: LocaleKeys.authEmptyResponse.tr());
    }
    return SuccessResponse.fromJson(data).success;
  }

  Future<bool> resendVerificationCode(
    ResendVerificationCodeRequest request,
  ) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.resendVerificationCode,
      data: request.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw ApiException(message: LocaleKeys.authEmptyResponse.tr());
    }
    return SuccessResponse.fromJson(data).success;
  }

  Future<void> logout() async {
    try {
      await _apiClient.post<void>(ApiEndpoints.logout);
    } catch (_) {}
    await _tokenStorage.clear();
  }

  Future<bool> hasToken() async {
    final accessToken = await _tokenStorage.getAccessToken();

    return accessToken != null && accessToken.isNotEmpty;
  }
}
