import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/navigation_history.dart';
import '../../../../core/utils/token_storage.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../view_models/splash_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashViewModel viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await TokenStorage.getToken();
      print('🔐 Token at splash: $token');
      await Future.delayed(const Duration(seconds: 2)); // optional
      viewModel.validateSession(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          final lastRoute = NavigationHistory.lastAttemptedRoute;
          if (lastRoute != null && lastRoute != '/login') {
            GoRouter.of(context).go(lastRoute);
            NavigationHistory.clear();
          } else {
            GoRouter.of(context).go('/home');
          }
        } else if (state is AuthFailure) {
          GoRouter.of(context).go('/login');
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
