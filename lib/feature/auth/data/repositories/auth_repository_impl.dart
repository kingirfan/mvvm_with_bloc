import 'package:dio/dio.dart';

import '../../../../core/app/enviornment.dart';
import '../../../../core/utils/token_storage.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this.tokenStorage);

  final Dio _dio;
  final TokenStorage tokenStorage;

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      Environment.signIn,
      data: {'email': email, 'password': password},
      options: Options(headers: Environment.defaultHeaders),
    );

    final token = response.data['result']['token'];
    // await TokenStorage.setToken(token);
    await tokenStorage.setToken(token);
    return token;
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      final response = await _dio.post(
        Environment.validateToken,
        options: Options(headers: {'X-Parse-Session-Token': token}),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String cpf,
  }) async {
    final response = await _dio.post(
      Environment.signUp,
      data: {
        'email': email,
        'password': password,
        'fullname': fullName,
        'phone': phone,
        'cpf': cpf,
      },
      options: Options(headers: Environment.defaultHeaders),
    );

    final token = response.data['result']['token'];
    // await TokenStorage.setToken(token);
    await tokenStorage.setToken(token);
    ;
    return token;
  }
}
