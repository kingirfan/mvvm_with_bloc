import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/data/repositories/home_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late HomeRepositoryImpl homeRepositoryImpl;

  setUp(() {
    mockDio = MockDio();
    homeRepositoryImpl = HomeRepositoryImpl(mockDio);
  });

  test('should call dio post for get categories when url is call', () async {
    final responsePayload = {
      'result': [
        {"title": "Cereais", "id": "aGN3NQKlXp"},
      ],
    };

    final response = Response(
      requestOptions: RequestOptions(path: Environment.getAllCategory),
      statusCode: 200,
      data: responsePayload,
    );

    when(
      () => mockDio.post(
        Environment.getAllCategory,
        options: any(named: 'options'),
      ),
    ).thenAnswer((invocation) async => response);

    final result = await homeRepositoryImpl.getCategories();
    expect(result.length, 1);
    expect(result.first.title, 'Cereais');
    expect(result.first.id, 'aGN3NQKlXp');
  });
}
