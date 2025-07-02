

import '../repository/auth_repository.dart';

class ValidateTokenUseCase {
  final AuthRepository repository;

  ValidateTokenUseCase(this.repository);

  Future<bool> call(String token) async {
    return repository.validateToken(token);
  }
}
