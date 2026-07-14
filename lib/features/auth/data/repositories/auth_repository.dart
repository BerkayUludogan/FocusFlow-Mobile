import 'package:easy_localization/easy_localization.dart';
import 'package:focusflow_mobile/core/network/api_client.dart';
import 'package:focusflow_mobile/core/network/api_endpoints.dart';
import 'package:focusflow_mobile/core/network/api_exception.dart';
import 'package:focusflow_mobile/core/storage/token_storage.dart';
import 'package:focusflow_mobile/features/auth/data/models/login_request.dart';
import 'package:focusflow_mobile/features/auth/data/models/login_response.dart';
import 'package:focusflow_mobile/product/localization/locale_keys.dart';

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
      throw ApiException(message: LocaleKeys.authEmptyLoginResponse.tr());
    }

    final loginResponse = LoginResponse.fromJson(data);

    await _tokenStorage.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    return loginResponse;
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
