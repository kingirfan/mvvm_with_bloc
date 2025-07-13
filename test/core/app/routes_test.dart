import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/app/routes.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/core/utils/helpers/navigation_service.dart';
import 'package:bloc_with_mvvm/core/utils/helpers/token_validator.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/login_page.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/splash_page.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockNavigationService extends Mock implements NavigationService {}

class MockTokenValidator extends Mock implements TokenValidator {}

void main() {
  final sl = GetIt.instance;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    whenListen(mockAuthBloc, Stream.fromIterable([AuthInitial()]));

    // Create mock instances
    final mockTokenStorage = MockTokenStorage();
    final mockNavigationService = MockNavigationService();
    final mockTokenValidator = MockTokenValidator();

    // Register mocks in GetIt
    if (!sl.isRegistered<TokenStorage>()) {
      sl.registerLazySingleton<TokenStorage>(() => mockTokenStorage);
    }

    if (!sl.isRegistered<NavigationService>()) {
      sl.registerLazySingleton<NavigationService>(() => mockNavigationService);
    }

    if (!sl.isRegistered<TokenValidator>()) {
      sl.registerLazySingleton<TokenValidator>(() => mockTokenValidator);
    }

    // ✅ Stub AFTER registering
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
  });

  tearDown(() async {
    await sl.reset();
  });

  /// App wrapper
  Widget createTestableApp(GoRouter router) {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp.router(routerConfig: router),
    );
  }

  testWidgets('navigates to /splash → SplashPage', (tester) async {
    final testRouter = buildRouter(initialLocation: '/splash');

    await tester.pumpWidget(createTestableApp(testRouter));

    expect(find.byType(SplashPage), findsOneWidget);

    // simulate the 2s delay
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('redirects to /login from splash when token is null', (tester) async {
    final mockTokenStorage = sl<TokenStorage>() as MockTokenStorage;
    final mockTokenValidator = sl<TokenValidator>() as MockTokenValidator;

    // simulate no token present
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);

    // this is required only if a token is returned and checked for validity
    when(() => mockTokenValidator.isValid(any())).thenAnswer((_) async => false);

    // Emit AuthFailure to trigger redirect to /login
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        AuthInitial(),
        const AuthFailure(UnknownException()),
      ]),
      initialState: AuthInitial(),
    );

    final testRouter = buildRouter(initialLocation: '/splash');

    await tester.pumpWidget(createTestableApp(testRouter));

    // Should start with SplashPage
    expect(find.byType(SplashPage), findsOneWidget);

    // Simulate the 2 second delay inside splash
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // for state/frame updates after delay

    // Final screen should be login
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('redirects to /home from splash when token is valid', (tester) async {
    final mockTokenStorage = sl<TokenStorage>() as MockTokenStorage;
    final mockTokenValidator = sl<TokenValidator>() as MockTokenValidator;

    // Setup: token exists and is valid
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => 'valid-token');
    when(() => mockTokenValidator.isValid('valid-token')).thenAnswer((_) async => true);

    // Simulate Bloc emitting success after splash validation
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([
        AuthInitial(),
        AuthLoading(),
        const AuthSuccess('Token valid'),
      ]),
      initialState: AuthInitial(),
    );

    final router = buildRouter(initialLocation: '/splash');

    await tester.pumpWidget(createTestableApp(router));

    // Should show SplashPage first
    expect(find.byType(SplashPage), findsOneWidget);

    // Simulate 2s splash delay + trigger AuthSuccess
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));

    // ✅ Should now land on HomePage
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('renders 404 page on unknown route', (tester) async {
    final router = buildRouter(initialLocation: '/unknown'); // Invalid route

    await tester.pumpWidget(createTestableApp(router));

    await tester.pumpAndSettle(); // Allow routing to complete

    // ✅ Assert that the error screen is shown
    expect(find.textContaining('Route not found'), findsOneWidget);
    expect(find.textContaining('/unknown'), findsOneWidget);
  });


}
