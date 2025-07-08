import 'package:bloc_with_mvvm/feature/auth/domain/repository/auth_repository.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  test('should return a token when login is successful', () async {
    const email = 'test@gmail.com';
    const password = 'password@123';
    const token = 'valid_token';

    when(() => mockAuthRepository.login(email: email, password: password)).thenAnswer((invocation) async => token);

    final result = await loginUseCase(email: email, password: password);

    expect(result, token);

    verify(() => mockAuthRepository.login(email: email, password: password)).called(1);

  });
}
