import 'package:dio/dio.dart';
import '../di/locator.dart';

class DioClient {
  static Dio get dio => sl<Dio>();
}
