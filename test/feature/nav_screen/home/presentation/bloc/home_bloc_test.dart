import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/product_usecase.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryUseCase extends Mock implements CategoryUseCase {}
class MockProductUseCase extends Mock implements ProductUseCase {}

void main() {
  late MockCategoryUseCase mockCategoryUseCase;
  late MockProductUseCase mockProductUseCase;
  late HomePageBloc homePageBloc;

  const category1 = CategoryModel(id: 'aGN3NQKlXp', title: 'Cereais');
  const category2 = CategoryModel(id: 'aGN3NQKlXy', title: 'Vegetables');

  final categoryList = [category1, category2];

  const mockCategoryId = 'cat123';

  final mockProductList = [
    ProductModel(id: '1', title: 'Banana', price: 10),
    ProductModel(id: '2', title: 'Apple', price: 15),
  ];

  setUp(() {
    mockCategoryUseCase = MockCategoryUseCase();
    mockProductUseCase = MockProductUseCase();
    homePageBloc = HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
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
      'emits new state if selected category is different and loads products',
      build: () {
        when(() => mockProductUseCase(categoryId: category2.id))
            .thenAnswer((_) async => mockProductList); // ✅ FIXED
        return homePageBloc;
      },
      seed: () => HomePageCategoryLoaded(categoryList, category1),
      act: (bloc) => bloc.add(SelectedCategoryEvent(category2, loadProducts: true)),
      expect: () => [
        HomePageCategoryLoaded(categoryList, category2),
        HomePageProductLoading(),
        HomePageProductLoaded(mockProductList),
      ],
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
        return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
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
        return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
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
        return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
      },
      act: (bloc) => bloc.add(LoadCategoriesEvent()),
      expect: () => [
        HomePageLoading(),
        const HomePageFailure(UnknownException()),
      ],
    );

    blocTest<HomePageBloc, HomePageState>(
      'emits [HomePageProductLoading, HomePageProductLoaded] when LoadProductEvent is added',
      build: () {
        when(() => mockProductUseCase(categoryId: mockCategoryId))
            .thenAnswer((_) async => mockProductList);
        return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
      },
      act: (bloc) => bloc.add(LoadProductEvent(categoryId: mockCategoryId)),
      expect: () => [
        HomePageProductLoading(),
        HomePageProductLoaded(mockProductList),
      ],
      verify: (_) {
        verify(() => mockProductUseCase(categoryId: mockCategoryId)).called(1);
      },
    );
  });

  blocTest<HomePageBloc, HomePageState>(
    'does NOT emit when DioException is cancel with UnauthorizedException',
    build: () {
      when(() => mockProductUseCase(categoryId: mockCategoryId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/getProductList'),
          type: DioExceptionType.cancel,
          error: const UnauthorizedException(),
        ),
      );
      return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
    },
    act: (bloc) => bloc.add(LoadProductEvent(categoryId: mockCategoryId)),
    expect: () => [
      HomePageProductLoading(), // Only loading state emitted
    ],
  );

  blocTest<HomePageBloc, HomePageState>(
    'emits failure with UnknownException for unknown errors',
    build: () {
      when(
            () => mockProductUseCase(categoryId: mockCategoryId),
      ).thenThrow(Exception('Unexpected error'));
      return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
    },
    act: (bloc) => bloc.add(LoadProductEvent(categoryId: mockCategoryId)),
    expect: () => [
      HomePageProductLoading(),
      const HomePageFailure(UnknownException()),
    ],
  );

  blocTest<HomePageBloc, HomePageState>(
    'emits failure when DioException is timeout',
    build: () {
      when(() => mockProductUseCase(categoryId: mockCategoryId)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/getAllProducts'),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      return HomePageBloc(categoryUseCase: mockCategoryUseCase,productUseCase: mockProductUseCase);
    },
    act: (bloc) => bloc.add(LoadProductEvent(categoryId: mockCategoryId)),
    expect: () => [HomePageProductLoading(), isA<HomePageFailure>()],
  );
}
