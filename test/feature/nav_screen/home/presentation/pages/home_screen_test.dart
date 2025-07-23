import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/bloc/home_event.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/pages/home_screen.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/presentation/view_models/HomePageViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomePageEvent extends Mock implements HomeEvent {}

class MockHomePageState extends Mock implements HomePageState {}

class MockHomePageBloc extends MockBloc<HomeEvent, HomePageState>
    implements HomePageBloc {}

class MockHomePageViewModel extends Mock implements HomePageViewModel {}

class MockBuildContext extends Mock implements BuildContext {}


void main() {
  late MockHomePageBloc mockHomePageBloc;
  late MockHomePageViewModel mockHomePageViewModel;
  late MockBuildContext mockBuildContext;

  setUpAll(() {
    registerFallbackValue(MockHomePageEvent());
    registerFallbackValue(MockHomePageState());
    registerFallbackValue(MockBuildContext());
  });

  setUp(() {
    mockHomePageBloc = MockHomePageBloc();
    mockBuildContext = MockBuildContext();
    mockHomePageViewModel = MockHomePageViewModel();
    when(() => mockHomePageViewModel.onSearchChanged(any(), any())).thenAnswer((_) {});
    when(() => mockHomePageBloc.state).thenReturn(HomePageInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<HomePageBloc>.value(
        value: mockHomePageBloc,
        child: const HomeScreen(),
      ),
    );
  }

  testWidgets('should show shimmer loader when state is loading', (
    tester,
  ) async {
    when(() => mockHomePageBloc.state).thenReturn(HomePageLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    // Expect shimmer list
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('should show category tiles when state is loaded', (
    tester,
  ) async {
    final categoryList = [
      CategoryModel.fromJson(const {"title": "Cereais", "id": "1"}),
      CategoryModel.fromJson(const {"title": "Frutas", "id": "2"}),
    ];

    when(
      () => mockHomePageBloc.state,
    ).thenReturn(HomePageCategoryLoaded(categoryList, categoryList.first));

    await tester.pumpWidget(createWidgetUnderTest());

    for (var category in categoryList) {
      expect(find.text(category.title), findsOneWidget);
    }
  });

  testWidgets('should show error text when state is failure', (tester) async {
    when(() => mockHomePageBloc.state).thenReturn(
      const HomePageFailure(ServerException('Server error occurred')),
    );

    whenListen(
      mockHomePageBloc,
      Stream<HomePageState>.fromIterable([
        const HomePageFailure(ServerException('Server error occurred')),
      ]),
    );
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Server error occurred'), findsOneWidget);
  });

  testWidgets('should call SelectedCategoryEvent when CategoryTile is tapped', (
    tester,
  ) async {
    // Arrange
    const category1 = CategoryModel(id: '1', title: 'Fruits');
    const category2 = CategoryModel(id: '2', title: 'Vegetables');
    const state = HomePageCategoryLoaded([category1, category2], category1);

    when(() => mockHomePageBloc.state).thenReturn(state);
    whenListen(mockHomePageBloc, Stream.fromIterable([state]));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pump();

    // Act
    await tester.tap(find.text('Vegetables'));
    await tester.pump();

    // Assert
    verify(
      () => mockHomePageBloc.add(SelectedCategoryEvent(category2)),
    ).called(1);
  });

  testWidgets('should show Item tiles when state is loaded', (tester) async {
    const productJson = {
      "id": "101",
      "title": "Corn Flakes",
      "description": "Delicious breakfast cereal",
      "price": 3.99,
      "imageUrl": "https://example.com/cornflakes.jpg",
      "categoryId": "1", // Matches the CategoryModel's ID
    };

    // Convert JSON to ProductModel
    final product = ProductModel.fromJson(productJson);

    final productList = [product];

    when(
      () => mockHomePageBloc.state,
    ).thenReturn(HomePageProductLoaded(productList));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    for (var product in productList) {
      expect(find.text(product.title ?? 'No tile found'), findsOneWidget);
    }
  });

  testWidgets('should call on Search when entered text', (tester) async {

    when(() => mockHomePageViewModel.onSearchChanged(any(), any()))
        .thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());

    // Act: Enter text into the search field
    final searchField = find.byKey(const Key('search_field'));
    await tester.enterText(searchField, 'test query');

    // Assert: Verify immediate call (should not happen due to debounce)
    verifyNever(() => mockHomePageViewModel.onSearchChanged(any(), any()));

    // Fast-forward 299ms (still no call)
    await tester.pump(const Duration(milliseconds: 299));
    verifyNever(() => mockHomePageViewModel.onSearchChanged(any(), any()));


  });
}
