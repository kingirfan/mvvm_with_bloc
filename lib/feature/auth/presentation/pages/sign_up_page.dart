import 'package:bloc_with_mvvm/core/utils/validators.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/view_models/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/custom_text_fields.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/utils/helpers/ui_helpers.dart';
import '../../../../core/utils/navigation_history.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final SignUpViewModel signUpViewModel = SignUpViewModel();

  @override
  void dispose() {
    signUpViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is AuthSuccess) {
            Navigator.of(context).pop();

            final lastRoute = NavigationHistory.lastAttemptedRoute;
            if (lastRoute != null && lastRoute != '/login') {
              GoRouter.of(context).go(lastRoute);
              NavigationHistory.clear();
            } else {
              GoRouter.of(context).go('/main_screen');
            }
          } else if (state is AuthFailure) {
            Navigator.of(context).pop();
            showAppError(context, state.error);
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 40,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(45),
                        ),
                      ),
                      child: Form(
                        key: signUpViewModel.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomTextField(
                              key: const Key('email_field'),
                              label: 'Email',
                              icon: Icons.email,
                              textEditingController:
                                  signUpViewModel.emailController,
                              validator: Validators.validateEmail,
                            ),
                            CustomTextField(
                              key: const Key('password_field'),
                              textEditingController:
                                  signUpViewModel.passwordController,
                              label: 'Password',
                              validator: Validators.validatePassword,
                              icon: Icons.lock,
                              isSecret: true,
                            ),
                            CustomTextField(
                              key: const Key('name'),
                              label: 'Name',
                              icon: Icons.person,
                              validator: (value) =>
                                  Validators.validateField(value, 'Name'),
                              textEditingController:
                                  signUpViewModel.fullNameController,
                            ),
                            CustomTextField(
                              key: const Key('phone_number'),
                              label: 'Phone Number',
                              icon: Icons.phone,
                              validator: (value) => Validators.validateField(
                                value,
                                'Phone Number',
                              ),
                              textEditingController:
                                  signUpViewModel.phoneController,
                              textInputType: TextInputType.phone,
                            ),
                            CustomTextField(
                              key: const Key('cpf'),
                              label: 'CPF',
                              validator: (value) =>
                                  Validators.validateField(value, 'CPF'),
                              textEditingController:
                                  signUpViewModel.cpfController,
                              icon: Icons.file_copy,
                              textInputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () {
                                  signUpViewModel.signUp(context);
                                },
                                child: const Text('Register User'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: SafeArea(
                    child: IconButton(
                      key: const Key('back'),
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
