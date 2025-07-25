import 'package:dio/dio.dart';

import 'app_exception.dart';

AppException mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const TimeoutException();
  }

  if (e.type == DioExceptionType.badResponse) {
    final data = e.response?.data;

    if (data is Map<String, dynamic> && data.containsKey('error')) {
      return ServerException(data['error']);
    }

    return const ServerException(); // fallback
  }

  if (e.type == DioExceptionType.cancel && e.error is AppException) {
    return e.error as AppException;
  }

  if (e.type == DioExceptionType.unknown) {
    return const NetworkException();
  }

  return const UnknownException();
}
