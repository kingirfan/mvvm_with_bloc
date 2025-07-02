import 'package:dio/dio.dart';

import 'app_exception.dart';

AppException mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return const TimeoutException();
  }

  if (e.type == DioExceptionType.badResponse) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) return const UnauthorizedException();

    final message = e.response?.data?['message'] ??
        e.response?.data?['error'] ??
        'Unexpected server error';
    return ServerException(message.toString());
  }

  if (e.type == DioExceptionType.unknown &&
      e.message?.contains('SocketException') == true) {
    return const NetworkException();
  }

  return UnknownException(e.message);
}
