import 'package:dio/dio.dart';
import 'package:focusflow_mobile/core/network/api_exception.dart';

class ApiErrorMapper {
  const ApiErrorMapper._();

  static ApiException map(Object error) {
    if (error is DioException) {
      return _mapDioException(error);
    }
    return ApiException(message: error.toString());
  }

  static ApiException _mapDioException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      final errors = data['errors'];

      if (error is List) {
        return ApiException(
          message: errors.isNotEmpty
              ? errors.first.toString()
              : 'Bir hata oluştu.',
          statusCode: statusCode,
          errors: errors.map((error) => error.toString()).toList(),
        );
      }

      final message = data['message'] ?? data['title'] ?? data['detail'];

      if (message != null) {
        return ApiException(
          message: message.toString(),
          statusCode: statusCode,
        );
      }
    }
    if (statusCode == 401) {
      return const ApiException(
        message: 'Oturum süresi doldu. Lütfen tekrar giriş yap.',
        statusCode: 401,
      );
    }
    if (statusCode == 429) {
      return const ApiException(
        message: 'Çok fazla istek gönderdin. Lütfen biraz bekle.',
        statusCode: 429,
      );
    }
    return ApiException(
      message: error.message ?? 'Sunucuya bağlanırken bir hata oluştu.',
      statusCode: statusCode,
    );
  }
}
