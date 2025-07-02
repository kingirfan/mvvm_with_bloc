import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/enviornment.dart';
import '../../app/routes.dart'; // navigatorKey
import '../../utils/navigation_history.dart';
import '../../utils/token_storage.dart';
import '../../utils/exceptions/app_exception.dart';
import '../dio_client.dart';

class AuthInterceptor extends Interceptor {
  final _unauthenticatedPaths = ['/login', '/signup', '/validate-token'];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // ✅ Skip token check for whitelisted paths
    if (_unauthenticatedPaths.any((path) => options.path.contains(path))) {
      return handler.next(options);
    }

    // ✅ Get stored token
    final token = await TokenStorage.getToken();

    if (token == null) {
      return _redirectToLogin(handler, "No token found");
    }

    final isValid = await _validateToken(token);

    if (!isValid) {
      return _redirectToLogin(handler, "Token expired");
    }

    // ✅ Token valid — attach it to request
    options.headers['X-Parse-Session-Token'] = token;
    handler.next(options);
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await DioClient.dio.post(
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

  Future<void> _redirectToLogin(
      RequestInterceptorHandler handler,
      String reason,
      ) async {
    final context = navigatorKey.currentContext;

    if (context != null) {
      // ✅ Save current route
      final router = GoRouter.of(context);
      final uri = router.routerDelegate.currentConfiguration.uri.toString();
      NavigationHistory.lastAttemptedRoute = uri;

      router.go('/login');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🔐 Session expired: $reason")),
      );
    }

    handler.reject(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
        error: const UnauthorizedException(),
      ),
      true,
    );
  }

}
