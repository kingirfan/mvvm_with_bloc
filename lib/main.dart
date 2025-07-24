import 'package:bloc_with_mvvm/core/di/locator.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/bloc/cart_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app/app_widget.dart';
import 'feature/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<HomePageBloc>(create: (_) => sl<HomePageBloc>()),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
