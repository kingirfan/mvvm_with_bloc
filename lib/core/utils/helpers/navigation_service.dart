// lib/core/utils/helpers/navigation_service.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../navigation_history.dart';

abstract class NavigationService {
  String getCurrentRoute();

  void goToLogin({required String reason});

  void saveAttemptedRoute(String path);
}

class NavigationServiceImpl implements NavigationService {
  @override
  String getCurrentRoute() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return GoRouter.of(
        context,
      ).routerDelegate.currentConfiguration.uri.toString();
    }
    return '/';
  }

  @override
  void saveAttemptedRoute(String path) {
    NavigationHistory.lastAttemptedRoute = path;
  }

  @override
  void goToLogin({required String reason}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      GoRouter.of(context).go('/login');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('🔐 Session expired: $reason')));
    }
  }
}
