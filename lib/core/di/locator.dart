import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/data/repositories/cart_repositories_impl.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/repository/cart_repository.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/bloc/cart_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/product_usecase.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../feature/auth/data/repositories/auth_repository_impl.dart';
import '../../feature/auth/domain/repository/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/domain/usecase/validate_token_usecase.dart';
import '../../feature/auth/presentation/bloc/auth_bloc.dart';

import '../../feature/nav_screen/cart/domain/usecase/cart_usecase.dart';
import '../../feature/nav_screen/home/data/repositories/home_repository_impl.dart';
import '../../feature/nav_screen/home/domain/repository/home_repository.dart';
import '../../feature/nav_screen/home/domain/usecase/category_usecase.dart';
import '../../feature/nav_screen/home/presentation/bloc/home_bloc.dart';
import '../network/interceptor/auth_interceptor.dart';
import '../utils/helpers/navigation_service.dart';
import '../utils/helpers/token_validator.dart';

final sl = GetIt.instance;

Future<void> setUpLocator() async {
  sl.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());
  sl.registerLazySingleton<TokenStorage>(() => TokenStorageImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<CartRepository>(() => CartRepositoriesImpl(sl()));

  // Dio for TokenValidator only (no AuthInterceptor)
  sl.registerLazySingleton<Dio>(
    instanceName: 'tokenValidatorDio',
    () => Dio(
      BaseOptions(
        baseUrl: Environment.baseUrl,
        headers: Environment.defaultHeaders,
      ),
    ),
  );

  // Token Validator
  sl.registerLazySingleton<TokenValidator>(
    () => TokenValidatorImpl(sl<Dio>(instanceName: 'tokenValidatorDio')),
  );

  // AuthInterceptor (depends on TokenValidator)
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      sl<TokenStorage>(),
      sl<NavigationService>(),
      sl<TokenValidator>(),
    ),
  );

  // Dio for app (includes AuthInterceptor)
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

  // Auth UseCases
  sl.registerLazySingleton(() => ValidateTokenUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));

  // Home Screen UseCase
  sl.registerLazySingleton(() => CategoryUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => ProductUseCase(sl<HomeRepository>()));

  // Cart UseCase CartUseCase
  sl.registerLazySingleton(() => CartUseCase(sl<CartRepository>()));

  // Auth BLoCs
  sl.registerFactory(
    () => AuthBloc(
      validateTokenUseCase: sl(),
      loginUseCase: sl(),
      signUpUseCase: sl(),
    ),
  );

  // Home Bloc
  sl.registerFactory(
    () => HomePageBloc(categoryUseCase: sl(), productUseCase: sl()),
  );

  // Cart Bloc
  sl.registerFactory(() => CartBloc(cartUseCase: sl()));
}
