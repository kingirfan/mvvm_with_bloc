import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/login_usecase.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/validate_token_usecase.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockValidateUseCase extends Mock implements ValidateTokenUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockValidateUseCase mockValidateUseCase;
  late AuthBloc authBloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockValidateUseCase = MockValidateUseCase();
    authBloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      validateTokenUseCase: mockValidateUseCase,
      signUpUseCase: mockSignUpUseCase,
    );
  });

  group('Auth Bloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when valid token requested succeeds',
      build: () {
        when(
          () => mockValidateUseCase('valid_token'),
        ).thenAnswer((invocation) async => true);
        return authBloc;
      },
      act: (bloc) => bloc.add(const ValidateTokenRequested('valid_token')),
      expect: () => [AuthLoading(), const AuthSuccess('Token valid')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Unauthenticated] when ValidateTokenRequested fails',
      build: () {
        when(
          () => mockValidateUseCase('invalid_token'),
        ).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(const ValidateTokenRequested('invalid_token')),
      expect: () => [
        AuthLoading(),
        const AuthFailure(UnauthorizedException()), // ✅
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure(ServerException)] when DioException occurs during token validation',
      build: () {
        when(() => mockValidateUseCase(any())).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/validate-token'),
            type: DioExceptionType.badResponse,
          ),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const ValidateTokenRequested('some_token')),
      expect: () => [
        AuthLoading(),
        const AuthFailure(ServerException()), // assuming mapDioError maps this
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure(UnknownException)] when unknown exception occurs',
      build: () {
        when(() => mockValidateUseCase(any())).thenThrow(Exception('Unexpected'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ValidateTokenRequested('any_token')),
      expect: () => [
        AuthLoading(),
        isA<AuthFailure>().having(
              (s) => s.error,
          'error',
          isA<UnknownException>(),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] when LoginRequested succeeds',
      build: () {
        when(
          () => mockLoginUseCase(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => 'token_123');
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [AuthLoading(), const AuthSuccess('token_123')],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError, Unauthenticated] when LoginRequested throws',
    build: () {
      when(
        () => mockLoginUseCase(email: 'fail@example.com', password: 'fail123'),
      ).thenThrow(Exception('Login failed'));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthLoginRequested(email: 'fail@example.com', password: 'fail123'),
    ),
    expect: () => [AuthLoading(), const AuthFailure(UnknownException())],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, Authenticated] when SignUpRequested succeeds',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: 'new@user.com',
          password: 'password123',
          fullName: 'New User',
          phone: '1234567890',
          cpf: '000.000.000-00',
        ),
      ).thenAnswer((_) async => 'token_abc');
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthSignUpRequested(
        email: 'new@user.com',
        password: 'password123',
        fullName: 'New User',
        phone: '1234567890',
        cpf: '000.000.000-00',
      ),
    ),
    expect: () => [AuthLoading(), const AuthSuccess('token_abc')],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure(ServerException)] when DioException occurs',
    build: () {
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.badResponse,
        ),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthLoginRequested(email: 'test@test.com', password: '1234'),
    ),
    expect: () => [
      AuthLoading(),
      const AuthFailure(ServerException()),
      // Make sure mapDioError maps this correctly
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading] only when DioException is cancel and error is UnauthorizedException during signup',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          phone: any(named: 'phone'),
          cpf: any(named: 'cpf'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/signup'),
          type: DioExceptionType.cancel,
          error: const UnauthorizedException(),
        ),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthSignUpRequested(
        email: 'test@test.com',
        password: '1234',
        fullName: 'Irfan',
        phone: '9876543210',
        cpf: '123.456.789-10',
      ),
    ),
    expect: () => [AuthLoading()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure(ServerException)] when DioException occurs during signup',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          phone: any(named: 'phone'),
          cpf: any(named: 'cpf'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/signup'),
          type: DioExceptionType.badResponse,
        ),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthSignUpRequested(
        email: 'test@test.com',
        password: '1234',
        fullName: 'Irfan',
        phone: '9876543210',
        cpf: '123.456.789-10',
      ),
    ),
    expect: () => [
      AuthLoading(),
      const AuthFailure(ServerException()),
      // Make sure mapDioError returns ServerException
    ],
  );



  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure(UnknownException)] when generic exception occurs during signup',
    build: () {
      when(
        () => mockSignUpUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          phone: any(named: 'phone'),
          cpf: any(named: 'cpf'),
        ),
      ).thenThrow(Exception('Unknown'));
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthSignUpRequested(
        email: 'test@test.com',
        password: '1234',
        fullName: 'Irfan',
        phone: '9876543210',
        cpf: '123.456.789-10',
      ),
    ),
    expect: () => [AuthLoading(), const AuthFailure(UnknownException())],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading] only when DioException is cancel and error is UnauthorizedException during login',
    build: () {
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.cancel,
          error: const UnauthorizedException(),
        ),
      );
      return authBloc;
    },
    act: (bloc) => bloc.add(
      const AuthLoginRequested(email: 'test@test.com', password: '1234'),
    ),
    expect: () => [AuthLoading()],
  );
}
