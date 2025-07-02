import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/exceptions/app_exception.dart';
import '../../../../core/utils/exceptions/exception_mapper.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/validate_token_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final ValidateTokenUseCase validateTokenUseCase;

  AuthBloc({required this.loginUseCase, required this.validateTokenUseCase})
    : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<ValidateTokenRequested>(_onValidateTokenRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await loginUseCase(email: event.email, password: event.password);
      emit(AuthSuccess(token));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel && e.error is UnauthorizedException) return;

      emit(AuthFailure(mapDioError(e)));
    } catch (e) {
      emit(const AuthFailure(UnknownException()));
    }
  }

  Future<void> _onValidateTokenRequested(
    ValidateTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      print('🔄 Validating token: ${event.token}');
      final isValid = await validateTokenUseCase(event.token);
      print('✔️ Validation result: $isValid');
      if (isValid) {
        emit(const AuthSuccess('Token valid'));
      } else {
        emit(const AuthFailure(UnauthorizedException()));
      }
    } on DioException catch (e) {
      emit(AuthFailure(mapDioError(e)));
    } catch (e) {
      emit(AuthFailure(UnknownException(e.toString())));
    }
  }
}
