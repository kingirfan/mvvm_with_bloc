abstract class AuthRepository {
  Future<String> login({required String email, required String password});

  Future<bool> validateToken(String token);

  Future<String> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cpf,
  });
}
