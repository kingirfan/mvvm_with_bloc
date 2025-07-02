// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../feature/auth/presentation/pages/login_page.dart';
// import '../../feature/auth/presentation/pages/splash_page.dart';
// import '../utils/token_storage.dart';
//
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// final router = GoRouter(
//   navigatorKey: navigatorKey,
//   initialLocation: '/splash',
//   routes: [
//     GoRoute(
//       path: '/login',
//       name: 'login',
//       builder: (context, state) => const LoginPage(),
//     ),
//     GoRoute(
//       path: '/splash',
//       builder: (context, _) => const SplashPage(),
//     ),
//     // GoRoute(
//     //   path: '/home',
//     //   name: 'home',
//     //   builder: (context, state) => const HomePage(),
//     // ),
//   ],
//   redirect: (context, state) async {
//     final token = await TokenStorage.getToken();
//
//     final isLoggingIn = state.matchedLocation == '/login';
//
//     if (token == null && !isLoggingIn) {
//       return '/login';
//     }
//
//     if (token != null && isLoggingIn) {
//       return '/home';
//     }
//
//     return null;
//   },
// );

import 'package:bloc_with_mvvm/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/auth/presentation/pages/splash_page.dart';
import '../../feature/home/presentation/pages/home_oage.dart';
// import '../../feature/home/presentation/pages/home_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const SignUpPage(),
    ),GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeOage(),
    ),
    // Add routes like cart, fav etc.
    // GoRoute(
    //   path: '/cart',
    //   name: 'cart',
    //   builder: (context, state) => const CartPage(),
    // ),
  ],
  // ✅ Let splash decide redirection — don't check token here
  redirect: (_, __) => null,
);


