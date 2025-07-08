abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppException && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class NetworkException extends AppException {
  const NetworkException() : super("No internet connection.");
}

class ServerException extends AppException {
  const ServerException([String? message])
    : super(message ?? "Something went wrong on the server.");
}

class UnauthorizedException extends AppException {
  const UnauthorizedException()
    : super("Session expired. Please log in again.");
}

class TimeoutException extends AppException {
  const TimeoutException() : super("Request timed out. Please try again.");
}

class UnknownException extends AppException {
  const UnknownException([String? message])
    : super(message ?? "An unknown error occurred.");
}
