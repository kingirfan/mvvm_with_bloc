import 'package:bloc_with_mvvm/core/network/interceptor/auth_interceptor.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/core/utils/helpers/navigation_service.dart';
import 'package:bloc_with_mvvm/core/utils/helpers/token_validator.dart';
import 'package:bloc_with_mvvm/core/utils/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

class MockNavigationService extends Mock implements NavigationService {}

class MockTokenValidator extends Mock implements TokenValidator {}

class TestRequestHandler extends RequestInterceptorHandler {
  final void Function(RequestOptions)? onNext;
  final void Function(DioException)? onReject;

  TestRequestHandler({this.onNext, this.onReject});

  @override
  void next(RequestOptions options) => onNext?.call(options);

  @override
  void reject(DioException err, [bool? force]) => onReject?.call(err);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockTokenStorage mockTokenStorage;
  late MockNavigationService mockNavigationService;
  late MockTokenValidator mockTokenValidator;
  late AuthInterceptor interceptor;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
    mockNavigationService = MockNavigationService();
    mockTokenValidator = MockTokenValidator();

    interceptor = AuthInterceptor(
      mockTokenStorage,
      mockNavigationService,
      mockTokenValidator,
    );
  });

  test('should redirect to login if no token found', () async {
    // Arrange
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => null);
    when(() => mockNavigationService.getCurrentRoute()).thenReturn('/cart');
    when(() => mockNavigationService.saveAttemptedRoute('/cart'))
        .thenAnswer((_) {}); // ✅ correct for void
    when(() => mockNavigationService.goToLogin(reason: any(named: 'reason')))
        .thenAnswer((_) {}); // ✅ correct for void

    final options = RequestOptions(path: '/cart');

    // Act
    await interceptor.onRequest(
      options,
      TestRequestHandler(
        onNext: (_) => fail('next should not be called'),
        onReject: (err) {
          expect(err.error, isA<UnauthorizedException>());
        },
      ),
    );

    // Assert
    verify(() => mockNavigationService.getCurrentRoute()).called(1);
    verify(() => mockNavigationService.saveAttemptedRoute('/cart')).called(1);
    verify(() => mockNavigationService.goToLogin(reason: any(named: 'reason')))
        .called(1);
  });


  test('should redirect to login if token is expired', () async {
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => 'expired_token');
    when(() => mockTokenValidator.isValid('expired_token')).thenAnswer((_) async => false);
    when(() => mockNavigationService.getCurrentRoute()).thenReturn('/checkout');
    when(() => mockNavigationService.saveAttemptedRoute('/checkout')).thenReturn(null);
    when(() => mockNavigationService.goToLogin(reason: any(named: 'reason')))
        .thenReturn(null);

    final options = RequestOptions(path: '/checkout');

    await interceptor.onRequest(
      options,
      TestRequestHandler(
        onNext: (_) => fail('next should not be called'),
        onReject: (err) {
          expect(err.error, isA<UnauthorizedException>());
        },
      ),
    );

    verify(() => mockNavigationService.getCurrentRoute()).called(1);
    verify(() => mockNavigationService.saveAttemptedRoute('/checkout')).called(1);
    verify(() => mockNavigationService.goToLogin(reason: any(named: 'reason'))).called(1);
  });

  test('should proceed if token is valid', () async {
    when(() => mockTokenStorage.getToken()).thenAnswer((_) async => 'valid_token');
    when(() => mockTokenValidator.isValid('valid_token')).thenAnswer((_) async => true);

    final options = RequestOptions(path: '/cart');

    bool wasNextCalled = false;

    await interceptor.onRequest(
      options,
      TestRequestHandler(
        onNext: (_) => wasNextCalled = true,
        onReject: (_) => fail('should not reject for valid token'),
      ),
    );

    expect(wasNextCalled, isTrue);
  });
}
