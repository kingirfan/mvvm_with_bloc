import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../feature/auth/data/repositories/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/domain/usecase/validate_token_usecase.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';

import '../network/interceptor/auth_interceptor.dart';
import '../utils/helpers/navigation_service.dart';
import '../utils/helpers/token_validator.dart';

final sl = GetIt.instance;

Future<void> setUpLocator() async {
  // Navigation Service
  sl.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());

  // Register Token Storage
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl());

  // ✅ Dio setup first (so it's available for TokenValidator)
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Environment.baseUrl,
        headers: Environment.defaultHeaders,
      ),
    );

    dio.interceptors.add(sl<AuthInterceptor>());
    return dio;
  });

  // Token Validator
  sl.registerLazySingleton<TokenValidator>(() => TokenValidatorImpl(sl<Dio>()));

  // ✅ Register AuthInterceptor
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      sl<TokenStorage>(),
      sl<NavigationService>(),
      sl<TokenValidator>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => ValidateTokenUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      validateTokenUseCase: sl(),
      loginUseCase: sl(),
      signUpUseCase: sl(),
    ),
  );
}
