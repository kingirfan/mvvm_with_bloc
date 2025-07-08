// lib/core/utils/helpers/token_validator.dart

import 'package:dio/dio.dart';
import '../../app/enviornment.dart';

abstract class TokenValidator {
  Future<bool> isValid(String token);
}

class TokenValidatorImpl implements TokenValidator {
  final Dio dio;

  TokenValidatorImpl(this.dio);

  @override
  Future<bool> isValid(String token) async {
    try {
      final response = await dio.post(
        Environment.validateToken,
        data: {},
        options: Options(
          headers: {
            ...Environment.defaultHeaders,
            'X-Parse-Session-Token': token,
          },
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
