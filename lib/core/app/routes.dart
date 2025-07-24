import 'package:bloc_with_mvvm/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:bloc_with_mvvm/feature/main_screen/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/auth/presentation/pages/splash_page.dart';
import '../../feature/nav_screen/home/presentation/pages/home_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Default router instance (used in prod app)
final router = buildRouter();

/// Builds a fresh GoRouter (for tests or overrides)
GoRouter buildRouter({String initialLocation = '/splash'}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignUpPage()),
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   pageBuilder: (context, state) =>
      //       MaterialPage(key: state.pageKey, child: const HomeScreen()),
      // ),
      GoRoute(
        path: '/main_screen',
        name: 'main_screen',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const MainScreen()),
      ),
    ],
    redirect: (context, state) {
      // Add authentication logic here if needed
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Route not found: ${state.uri.toString()}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}
