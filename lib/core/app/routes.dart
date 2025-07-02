import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/pages/login_page.dart';
import '../utils/token_storage.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    // GoRoute(
    //   path: '/home',
    //   name: 'home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
  redirect: (context, state) async {
    final token = await TokenStorage.getToken();

    final isLoggingIn = state.matchedLocation == '/login';

    if (token == null && !isLoggingIn) {
      return '/login';
    }

    // if (token != null && isLoggingIn) {
    //   return '/home';
    // }

    return null;
  },
);
