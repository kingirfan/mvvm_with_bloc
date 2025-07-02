import 'package:bloc_with_mvvm/feature/auth/domain/repository/auth_repository.dart';

class SignUpUseCase {
  SignUpUseCase(this.authRepository);

  final AuthRepository authRepository;

  Future<String> call({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cpf,
  }) {
    return authRepository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      cpf: cpf,
    );
  }
}
