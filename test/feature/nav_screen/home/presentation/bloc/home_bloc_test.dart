import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryUseCase extends Mock implements CategoryUseCase {}

void main() {
  late MockCategoryUseCase mockCategoryUseCase;
  late HomePageBloc homePageBloc;

  final category1 = CategoryModel(id: 'aGN3NQKlXp', title: 'Cereais');
  final category2 = CategoryModel(id: 'aGN3NQKlXy', title: 'Vegetables');

  final categoryList = [category1, category2];

  setUp(() {
    mockCategoryUseCase = MockCategoryUseCase();
    homePageBloc = HomePageBloc(categoryUseCase: mockCategoryUseCase);
  });

  group('Home Bloc', () {
    blocTest<HomePageBloc, HomePageState>(
      'emit [HomePageLoading , HomePageCategoryLoaded]',
      build: () {
        when(
          () => mockCategoryUseCase(),
        ).thenAnswer((invocation) async => categoryList);
        return homePageBloc;
      },
      act: (bloc) => bloc.add(LoadCategoriesEvent()),
      expect: () => [
        HomePageLoading(),
        HomePageCategoryLoaded(
          categoryList,
          categoryList.isNotEmpty ? categoryList.first : null,
        ),
      ],
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits new state if selected category is different',
      build: () => homePageBloc,
      seed: () => HomePageCategoryLoaded(categoryList, category1),
      act: (bloc) => bloc.add(SelectedCategoryEvent(category2)),
      expect: () => [HomePageCategoryLoaded(categoryList, category2)],
    );

    blocTest<HomePageBloc, HomePageState>(
      'does not emit if selected category is already selected',
      build: () => homePageBloc,
      seed: () => HomePageCategoryLoaded(categoryList, category1),
      act: (bloc) => bloc.add(SelectedCategoryEvent(category1)),
      expect: () => [], // No state change expected
    );

    blocTest<HomePageBloc, HomePageState>(
      'does NOT emit when DioException is cancel with UnauthorizedException',
      build: () {
        when(() => mockCategoryUseCase()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/getAllCategories'),
            type: DioExceptionType.cancel,
            error: const UnauthorizedException(),
          ),
        );
        return HomePageBloc(categoryUseCase: mockCategoryUseCase);
      },
      act: (bloc) => bloc.add(LoadCategoriesEvent()),
      expect: () => [
        HomePageLoading(), // Only loading state emitted
      ],
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits failure when DioException is timeout',
      build: () {
        when(() => mockCategoryUseCase()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/getAllCategories'),
            type: DioExceptionType.connectionTimeout,
          ),
        );
        return HomePageBloc(categoryUseCase: mockCategoryUseCase);
      },
      act: (bloc) => bloc.add(LoadCategoriesEvent()),
      expect: () => [HomePageLoading(), isA<HomePageFailure>()],
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits failure with UnknownException for unknown errors',
      build: () {
        when(
          () => mockCategoryUseCase(),
        ).thenThrow(Exception('Unexpected error'));
        return HomePageBloc(categoryUseCase: mockCategoryUseCase);
      },
      act: (bloc) => bloc.add(LoadCategoriesEvent()),
      expect: () => [
        HomePageLoading(),
        const HomePageFailure(UnknownException()),
      ],
    );
  });
}
