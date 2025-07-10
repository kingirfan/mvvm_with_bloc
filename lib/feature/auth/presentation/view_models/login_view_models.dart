import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class LoginViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  void login(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text;

    final bloc = BlocProvider.of<AuthBloc>(context);
    bloc.add(AuthLoginRequested(email: email, password: password));
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
