import 'package:dio/dio.dart';

import '../../../../core/app/enviornment.dart';
import '../../../../core/utils/token_storage.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);

  final Dio _dio;

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
    await TokenStorage.setToken(token);
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
}
