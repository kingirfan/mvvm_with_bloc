import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/core/utils/helpers/token_validator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late TokenValidator tokenValidator;

  setUp(() {
    mockDio = MockDio();
    tokenValidator = TokenValidatorImpl(mockDio);
  });

  test('should return true when server returns 200', () async {
    when(
      () => mockDio.post(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async =>
          Response(requestOptions: RequestOptions(path: ''), statusCode: 200),
    );

    final result = await tokenValidator.isValid('any_token');
    expect(result, true);
  });

  test('should return false when status code is not 200', () async {
    // Arrange
    when(
      () => mockDio.post(
        Environment.validateToken,
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async =>
          Response(requestOptions: RequestOptions(path: ''), statusCode: 401),
    );

    // Act
    final result = await tokenValidator.isValid('invalid_token');

    // Assert
    expect(result, false);
  });

  test('should return false when Dio throws an exception', () async {
    // Arrange
    when(
      () => mockDio.post(
        Environment.validateToken,
        options: any(named: 'options'),
      ),
    ).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

    // Act
    final result = await tokenValidator.isValid('error_token');

    // Assert
    expect(result, false);
  });
}
