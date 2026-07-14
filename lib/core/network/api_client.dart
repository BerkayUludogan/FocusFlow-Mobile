import 'package:dio/dio.dart';
import 'package:focusflow_mobile/core/network/api_endpoints.dart';
import 'package:focusflow_mobile/core/network/api_error_mapper.dart';

import '../constants/app_constants.dart';
import '../storage/token_storage.dart';

class ApiClient {
  factory ApiClient({required TokenStorage tokenStorage, Dio? dio}) {
    return ApiClient._(tokenStorage, dio);
  }
  Future<String>? _refreshFuture;

  Future<String> _refreshAccessToken(String refreshToken) {
    return _refreshFuture ??= _doRefresh(refreshToken).whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String> _doRefresh(String refreshToken) async {
    final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));
    final response = await refreshDio.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    final newAccessToken = response.data['accessToken'] as String;
    final newRefreshToken = response.data['refreshToken'] as String;
    await _tokenStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
    return newAccessToken;
  }

  ApiClient._(this._tokenStorage, Dio? dio)
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              sendTimeout: const Duration(seconds: 10),
              headers: {'Content-Type': 'application/json'},
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenStorage.getAccessToken();
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _tokenStorage.getRefreshToken();
            if (refreshToken == null || refreshToken.isEmpty) {
              await _tokenStorage.clear();
              return handler.next(error);
            }

            try {
              final newAccessToken = await _refreshAccessToken(refreshToken);

              final retryRequest = error.requestOptions;
              retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await _dio.fetch(retryRequest);
              return handler.resolve(retryResponse);
            } catch (_) {
              await _tokenStorage.clear();
              return handler.next(error);
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (error) {
      throw ApiErrorMapper.map(error);
    }
  }
}
