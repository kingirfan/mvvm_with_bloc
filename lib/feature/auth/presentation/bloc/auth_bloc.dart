import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final token = await loginUseCase(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess(token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
