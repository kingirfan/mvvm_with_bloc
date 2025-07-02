import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app/app_widget.dart';
import 'feature/auth/data/repositories/auth_repository_impl.dart';
import 'feature/auth/domain/usecase/login_usecase.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';

void main() {
  final dio = Dio(); // ✅ create Dio instance
  final authRepo = AuthRepositoryImpl(dio); // ✅ inject into repo

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(loginUseCase: LoginUseCase(authRepo)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
