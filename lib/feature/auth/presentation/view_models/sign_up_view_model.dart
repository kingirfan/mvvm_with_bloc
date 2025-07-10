import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class SignUpViewModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();

  void signUp(BuildContext context) {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text;
    final fullName = fullNameController.text;
    final phone = phoneController.text;
    final cpf = cpfController.text;

    final bloc = BlocProvider.of<AuthBloc>(context);

    bloc.add(
      AuthSignUpRequested(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        cpf: cpf,
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    cpfController.dispose();
  }
}
