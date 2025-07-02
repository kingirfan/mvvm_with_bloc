

import '../repository/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this.authRepository);

  final AuthRepository authRepository;

  Future<String> call({required String email, required String password}) {
    return authRepository.login(email: email, password: password);
  }
}
