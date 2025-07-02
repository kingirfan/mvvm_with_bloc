import 'package:bloc_with_mvvm/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../feature/auth/data/repositories/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/domain/usecase/validate_token_usecase.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> setUpLocator() async {
  // ✅ Register Dio
  sl.registerLazySingleton<Dio>(() => DioClient.dio);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

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
