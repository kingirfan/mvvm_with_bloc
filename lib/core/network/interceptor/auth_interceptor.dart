import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/helpers/navigation_service.dart';
import '../../utils/helpers/token_validator.dart';
import '../../utils/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final NavigationService _navigationService;
  final TokenValidator _tokenValidator;
  final _unauthenticatedPaths = ['/login', '/signup', '/validate-token'];

  AuthInterceptor(
    this._tokenStorage,
    this._navigationService,
    this._tokenValidator,
  );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_unauthenticatedPaths.any((path) => options.path.contains(path))) {
      return handler.next(options);
    }

    final token = await _tokenStorage.getToken();

    if (token == null) {
      return _redirectToLogin(handler, "No token found");
    }

    final isValid = await _tokenValidator.isValid(token);

    if (!isValid) {
      return _redirectToLogin(handler, "Token expired");
    }

    options.headers['X-Parse-Session-Token'] = token;
    handler.next(options);
  }

  Future<void> _redirectToLogin(
    RequestInterceptorHandler handler,
    String reason,
  ) async {
    final route = _navigationService.getCurrentRoute();
    _navigationService.saveAttemptedRoute(route);
    _navigationService.goToLogin(reason: reason);

    handler.reject(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.cancel,
        error: const UnauthorizedException(),
      ),
      true,
    );
  }
}
