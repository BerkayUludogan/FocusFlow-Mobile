import 'package:dio/dio.dart';
import 'package:focusflow_mobile/core/network/api_error_mapper.dart';

import '../constants/app_constants.dart';
import '../storage/token_storage.dart';

class ApiClient {
  factory ApiClient({required TokenStorage tokenStorage, Dio? dio}) {
    return ApiClient._(tokenStorage, dio);
  }

  ApiClient._(this._tokenStorage, Dio? dio)
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.developmentBaseUrl,
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
