import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/locator.dart';
import '../../../../core/utils/token_storage.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SplashViewModel {
  Future<void> validateSession(BuildContext context) async {
    final token = await sl<TokenStorage>().getToken();

    // ✅ Always delegate navigation to BlocListener
    context.read<AuthBloc>().add(ValidateTokenRequested(token ?? ''));
  }
}
