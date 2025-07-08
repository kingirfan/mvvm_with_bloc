import 'package:bloc_with_mvvm/feature/auth/domain/repository/auth_repository.dart';
import 'package:bloc_with_mvvm/feature/auth/domain/usecase/validate_token_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ValidateTokenUseCase validateTokenUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    validateTokenUseCase = ValidateTokenUseCase(mockAuthRepository);
  });

  test('should return true when token is valid', () async {
    const token = 'valid_token';

    when(
      () => mockAuthRepository.validateToken(token),
    ).thenAnswer((invocation) async => true);

    final result = await validateTokenUseCase(token);

    expect(result, true);

    verify(() => mockAuthRepository.validateToken(token)).called(1);
  });

  test('should return false when token is valid', () async {
    const token = 'valid_token';

    when(
          () => mockAuthRepository.validateToken(token),
    ).thenAnswer((invocation) async => false);

    final result = await validateTokenUseCase(token);

    expect(result, false);

    verify(() => mockAuthRepository.validateToken(token)).called(1);
  });


}
