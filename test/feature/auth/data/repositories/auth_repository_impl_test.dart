import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';
import 'package:bloc_with_mvvm/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockDio mockDio;
  late MockTokenStorage mockTokenStorage;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    mockDio = MockDio();
    mockTokenStorage = MockTokenStorage();
    authRepositoryImpl = AuthRepositoryImpl(mockDio, mockTokenStorage);
  });

  test(
    'should call dio post for login with correct url and store token',
    () async {
      const email = 'test@example.com';
      const password = '1234@password';
      const token = 'valid_token';

      final responsePayload = {
        'result': {'token': token},
      };

      final response = Response(
        requestOptions: RequestOptions(path: Environment.signIn),
        statusCode: 200,
        data: responsePayload,
      );

      when(
        () => mockDio.post(
          Environment.signIn,
          data: {'email': email, 'password': password},
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      when(
        () => mockTokenStorage.setToken(token),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.login(
        email: email,
        password: password,
      );

      expect(result, token);
      verify(
        () => mockDio.post(
          Environment.signIn,
          data: {'email': email, 'password': password},
          options: any(named: 'options'),
        ),
      ).called(1);

      verify(() => mockTokenStorage.setToken(token)).called(1);
    },
  );

  test(
    'should call dio for sign up with correct url and store token',
    () async {
      const email = 'test@test.com';
      const password = 'password@1234';
      const fullName = 'irfan';
      const phone = '9840466567';
      const cpf = '123.456.789-10';

      const token = 'valid_token';

      final responsePayload = {
        'result': {'token': token},
      };

      final response = Response(
        requestOptions: RequestOptions(path: Environment.signUp),
        statusCode: 200,
        data: responsePayload,
      );

      when(
        () => mockDio.post(
          Environment.signUp,
          data: {
            'email': email,
            'password': password,
            'fullname': fullName,
            'phone': phone,
            'cpf': cpf,
          },
          options: any(named: 'options'),
        ),
      ).thenAnswer((_) async => response);

      when(
        () => mockTokenStorage.setToken(token),
      ).thenAnswer((_) async => Future.value());

      // Act
      final result = await authRepositoryImpl.signUp(
        email: email,
        password: password,
        cpf: cpf,
        fullName: fullName,
        phone: phone,
      );

      expect(result, token);
    },
  );

  test('returns true when token is valid (statusCode 200)', () async {
    const token = 'valid_token';

    final response = Response(
      requestOptions: RequestOptions(path: Environment.validateToken),
      statusCode: 200,
      data: {},
    );

    when(() => mockDio.post(
      Environment.validateToken,
      options: any(named: 'options'),
    )).thenAnswer((_) async => response);

    final result = await authRepositoryImpl.validateToken(token);

    expect(result, true);
  });

  test('returns false when Dio throws unexpected exception', () async {
    // Arrange
    when(() => mockDio.post(
      Environment.validateToken,
      options: any(named: 'options'),
    )).thenThrow(Exception('network error')); // generic error

    // Act
    final result = await authRepositoryImpl.validateToken('dummy_token');

    // Assert
    expect(result, isFalse); // should hit catch and return false
  });

  test('returns false when Dio throws an exception', () async {
    const token = 'valid_token';

    // Arrange
    when(() => mockDio.post(
      Environment.validateToken,
      options: any(named: 'options'),
    )).thenThrow(DioException(
      requestOptions: RequestOptions(path: Environment.validateToken),
      type: DioExceptionType.badResponse,
    ));

    // Act
    final result = await authRepositoryImpl.validateToken(token);

    // Assert
    expect(result, isFalse);
  });
}
