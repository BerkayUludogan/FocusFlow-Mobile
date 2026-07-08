import 'package:dio/dio.dart';
import 'package:focusflow_mobile/core/storage/token_storage.dart';

class ApiClient {
  ApiClient({required TokenStorage tokenStorage, Dio? dio})
    : _tokenStorage = tokenStorage,
      _dio = dio ?? Dio() {}
}
