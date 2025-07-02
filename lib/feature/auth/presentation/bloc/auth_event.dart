import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String phone;
  final String cpf;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.cpf,
  });

  @override
  List<Object> get props => [email, password, fullName, phone, cpf];
}

class ValidateTokenRequested extends AuthEvent {
  final String token;

  const ValidateTokenRequested(this.token);
}
