import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/login_page.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthEvent extends Mock implements AuthEvent {}

class MockAuthState extends Mock implements AuthState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    registerFallbackValue(MockAuthEvent());
    registerFallbackValue(MockAuthState());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget createWidgetUnderTree() {
    final router = GoRouter(
      initialLocation: '/register',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),

        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(body: SignUpPage()),
        ),

        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('Login Page')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider<AuthBloc>.value(value: mockAuthBloc, child: child!);
      },
    );
  }

  testWidgets('shows CircularProgressIndicator on AuthLoading ', (
    tester,
  ) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthLoading()]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTree());
    await tester.pump(); // flush state

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('show Register fields', (tester) async {
    await tester.pumpWidget(createWidgetUnderTree());

    expect(find.byKey(const Key('email_field')), findsOneWidget);
    expect(find.byKey(const Key('password_field')), findsOneWidget);
    expect(find.byKey(const Key('name')), findsOneWidget);
    expect(find.byKey(const Key('phone_number')), findsOneWidget);
    expect(find.byKey(const Key('cpf')), findsOneWidget);
  });

  testWidgets('show validators error on empty field', (tester) async {
    await tester.pumpWidget(createWidgetUnderTree());

    await tester.enterText(find.byKey(const Key('email_field')), '');
    await tester.enterText(find.byKey(const Key('password_field')), '');
    await tester.enterText(find.byKey(const Key('name')), '');
    await tester.enterText(find.byKey(const Key('phone_number')), '');
    await tester.enterText(find.byKey(const Key('cpf')), '');

    final registerButton = find.text('Register User');
    expect(registerButton, findsOneWidget);

    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password must be at least 3 characters'), findsOneWidget);
    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Phone Number is required'), findsOneWidget);
    expect(find.text('CPF is required'), findsOneWidget);
  });

  testWidgets('Register form on valid input', (tester) async {
    await tester.pumpWidget(createWidgetUnderTree());

    await tester.enterText(
      find.byKey(const Key('email_field')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('password_field')), 'irfan');
    await tester.enterText(find.byKey(const Key('name')), 'Irfan');
    await tester.enterText(
      find.byKey(const Key('phone_number')),
      '(99) 99999-9999',
    );
    await tester.enterText(find.byKey(const Key('cpf')), '123.456.789-10');

    final registerButton = find.text('Register User');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    // Optional: Verify bloc event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<AuthSignUpRequested>())),
    ).called(1);
  });

  testWidgets('navigates to /home on AuthSuccess with no last route', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthLoading(), const AuthSuccess('valid_token')]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(createWidgetUnderTree());

    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('taps back button and pops the route', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginPage()),
        GoRoute(
          path: '/register',
          builder: (context, state) => const SignUpPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) {
          return BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: child!,
          );
        },
      ),
    );

    // Simulate navigation to SignUpPage
    router.push('/register');
    await tester.pumpAndSettle();

    // Now test back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    // ✅ Verify navigation back to LoginPage
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
