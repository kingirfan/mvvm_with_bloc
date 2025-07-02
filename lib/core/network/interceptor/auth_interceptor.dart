import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/enviornment.dart';
import '../../app/routes.dart'; // for navigatorKey
import '../../utils/token_storage.dart';
import '../../utils/navigation_history.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      return _redirectToLogin(handler, "No token found");
    }

    final isValid = await _validateToken(token);

    if (!isValid) {
      return _redirectToLogin(handler, "Token expired");
    }

    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  Future<bool> _validateToken(String token) async {
    try {
      final response = await Dio().post(
        Environment.validateToken,
        data: {},
        options: Options(
          headers: {
            ...Environment.defaultHeaders,
            'Authorization': 'Bearer $token',
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
      // ✅ Fixed: get current route properly
      NavigationHistory.lastAttemptedRoute = GoRouter.of(
        context,
      ).routerDelegate.currentConfiguration.uri.toString();

      GoRouter.of(context).go('/login');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("🔐 Session expired: $reason")));
    }

    handler.reject(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
        error: 'Session expired',
      ),
    );
  }
}
