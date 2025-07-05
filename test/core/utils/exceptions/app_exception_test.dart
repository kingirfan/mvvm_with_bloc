import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/exception_mapper.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/exception_mapper.dart'
    as ExceptionMapper;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exception Mapper', () {
    test('returns Timeout exception on timeout ', () {
      for (var type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
      ]) {
        final exception = DioException(
          requestOptions: RequestOptions(path: ''),
          type: type,
        );

        final result = mapDioError(exception);
        expect(result, isA<TimeoutException>());
      }
    });

    test('returns Server Exception with message when error key is present', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'error': 'Custom server error '},
          statusCode: 400,
        ),
      );

      final result = mapDioError(exception);
      expect(result, isA<ServerException>());
      expect(result.message, 'Custom server error ');
    });

    test('return Server Exception if error key is missing', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          data: {'data': 'some message'},
          statusCode: 400,
        ),
      );

      final result = mapDioError(exception);
      expect(result, isA<ServerException>());
    });

    test('returns AppException if cancel and is AppException', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
        error: const TimeoutException(),
      );

      final result = mapDioError(exception);
      expect(result, isA<TimeoutException>());
    });

    test('returns NetworkException for unknown type', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
      );

      final result = mapDioError(exception);
      expect(result, isA<NetworkException>());
    });

    test('returns UnknownException if none match', () {
      final exception = DioException(
        type: DioExceptionType.badCertificate, // unhandled type
        requestOptions: RequestOptions(path: ''),
      );

      final result = mapDioError(exception);
      expect(result, isA<UnknownException>());
    });
  });
}
