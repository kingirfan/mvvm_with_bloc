import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/repository/home_repository.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements HomeRepository {}

void main() {
  late CategoryUseCase categoryUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    categoryUseCase = CategoryUseCase(mockAuthRepository);
  });

  test('test should return a list when it is successful', () async {
    final expectedList = [
      CategoryModel.fromJson(const {"title": "Cereais", "id": "aGN3NQKlXp"}),
    ];

    when(
      () => mockAuthRepository.getCategories(),
    ).thenAnswer((invocation) async => expectedList);

    final result = await categoryUseCase();

    expect(result, expectedList);

    verify(() => mockAuthRepository.getCategories()).called(1);
  });
}
