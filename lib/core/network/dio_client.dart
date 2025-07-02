import 'package:dio/dio.dart';

import '../app/enviornment.dart';
import 'interceptor/auth_interceptor.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrl,
      headers: Environment.defaultHeaders,
    ),
  )..interceptors.add(AuthInterceptor());
}
