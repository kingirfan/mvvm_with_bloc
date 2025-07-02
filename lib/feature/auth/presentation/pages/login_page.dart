import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/appname_widget.dart';
import '../../../../common/widgets/custom_text_fields.dart';
import '../../../../core/theme/custom_colors.dart';
import '../../../../core/utils/helpers/ui_helpers.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../view_models/login_view_models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginViewModel viewModel = LoginViewModel();

  @override
  void dispose() {
    viewModel.dispose();
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
            debugPrint('login success');
            // context.go('/home');
          } else if (state is AuthFailure) {
            Navigator.of(context).pop();
            showAppError(context, state.error);
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppNameWidget(
                        greenColorTitle: Colors.white,
                        textSize: 40,
                      ),
                      SizedBox(
                        height: 30,
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 25),
                          child: AnimatedTextKit(
                            pause: Duration.zero,
                            repeatForever: true,
                            animatedTexts: [
                              FadeAnimatedText('Fruits'),
                              FadeAnimatedText('Vegetables'),
                              FadeAnimatedText('Meat'),
                              FadeAnimatedText('Cereals'),
                              FadeAnimatedText('Dairy'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
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
                      key: viewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            label: 'Email',
                            icon: Icons.email,
                            validator: Validators.validateEmail,
                            textEditingController: viewModel.emailController,
                          ),
                          CustomTextField(
                            label: 'Password',
                            icon: Icons.lock,
                            isSecret: true,
                            validator: (value) =>
                                Validators.validatePassword(value),
                            textEditingController: viewModel.passwordController,
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
                                viewModel.login(context);
                                //  Get.offNamed(PagesRoutes.baseRoute);
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          /*Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              final bool? resultIs = await showDialog(
                                context: context,
                                builder: (context) {
                                  return ForgotPasswordDialog(
                                    email: emailController.text,
                                  );
                                },
                              );

                              if (resultIs ?? false) {
                                utilServices.showToast(
                                    message:
                                    'a recovery link has been sent to your email');
                              }
                            },
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),*/
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.grey.withAlpha(90),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Text('Or'),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.grey.withAlpha(90),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                // Get.toNamed(PagesRoutes.signUpRoute);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2,
                                  color: Colors.green,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ),
                        ],
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
