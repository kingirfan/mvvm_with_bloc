import 'package:bloc_with_mvvm/feature/auth/domain/repository/auth_repository.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignUpUseCase signUpUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(mockAuthRepository);
  });

  test('should return a token when sign up is successful', () async {
    const email = 'test@test.com';
    const password = 'password@1234';
    const fullName = 'irfan';
    const phone = '9840466567';
    const cpf = '123.456.789-10';
    const token = 'valid_token';

    when(
      () => mockAuthRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        cpf: cpf,
      ),
    ).thenAnswer((invocation) async => token);

    final result = await signUpUseCase(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
      cpf: cpf,
    );

    expect(result, token);

    verify(
      () => mockAuthRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        cpf: cpf,
      ),
    ).called(1);
  });
}
