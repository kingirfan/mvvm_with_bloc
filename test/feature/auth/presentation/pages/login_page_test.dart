import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_event.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/bloc/auth_state.dart';
import 'package:bloc_with_mvvm/feature/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuthBlock extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late MockAuthBlock mockAuthBloc;
  final mockObserver = MockNavigatorObserver();

  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockAuthBloc = MockAuthBlock();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget createWidget() {

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Page')),
        ),

        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(body: Text('Register Page')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: child!,
        );
      },
    );

    // return MaterialApp(
    //   navigatorObservers: [mockObserver],
    //   home: BlocProvider<AuthBloc>.value(
    //     value: mockAuthBloc,
    //     child: const LoginPage(),
    //   ),
    // );
  }

  testWidgets('shows CircularProgressIndicator on AuthLoading', (tester) async {
    whenListen(
      mockAuthBloc,
      Stream.fromIterable([AuthLoading()]),
      initialState: AuthInitial(),
    );

    await tester.pumpWidget(createWidget());
    await tester.pump(); // flush state

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('show email and password fields', (widgetTester) async {
    await widgetTester.pumpWidget(createWidget());

    expect(find.byKey(const Key('email_field')), findsOneWidget);
    expect(find.byKey(const Key('password_field')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('show validators error on empty field', (widgetTester) async {
    await widgetTester.pumpWidget(createWidget());

    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);

    await widgetTester.enterText(find.byKey(const Key('email_field')), '');
    await widgetTester.enterText(find.byKey(const Key('password_field')), '');

    await widgetTester.tap(loginButton);
    await widgetTester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password must be at least 3 characters'), findsOneWidget);
  });

  testWidgets('submits form on valid input', (tester) async {
    await tester.pumpWidget(createWidget());

    await tester.enterText(
      find.byKey(const Key('email_field')),
      'test@example.com',
    );
    await tester.enterText(find.byKey(const Key('password_field')), '12345');

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Optional: Verify bloc event was added
    verify(
      () => mockAuthBloc.add(any(that: isA<AuthLoginRequested>())),
    ).called(1);
  });

  testWidgets('navigates to /home on AuthSuccess with no last route',
          (WidgetTester tester) async {
        whenListen(
          mockAuthBloc,
          Stream.fromIterable([
            AuthLoading(),
            const AuthSuccess('valid_token'),
          ]),
          initialState: AuthInitial(),
        );

        await tester.pumpWidget(createWidget());

        // Let the AuthSuccess be handled
        await tester.pumpAndSettle();

        // No exception = success
        expect(find.text('Home Page'), findsOneWidget);
      });



  testWidgets('navigates to register screen on Sign Up tap', (widgetTester) async {
    await widgetTester.pumpWidget(createWidget());
    await widgetTester.pumpAndSettle();

    // Tap the Sign Up button
    final signUpButton = find.text('Sign Up');
    expect(signUpButton, findsOneWidget);

    await widgetTester.ensureVisible(signUpButton);
    await widgetTester.tap(signUpButton);
    await widgetTester.pumpAndSettle();

    // Verify navigation to /register happened
    expect(find.text('Register Page'), findsOneWidget);
  });

}
