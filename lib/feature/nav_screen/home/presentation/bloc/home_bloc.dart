import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/product_usecase.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/exceptions/app_exception.dart';
import '../../../../../core/utils/exceptions/exception_mapper.dart';
import '../../../../models/category_model.dart';
import 'home_event.dart';

part 'home_state.dart';

class HomePageBloc extends Bloc<HomeEvent, HomePageState> {
  final CategoryUseCase categoryUseCase;
  final ProductUseCase productUseCase;

  HomePageBloc({required this.categoryUseCase, required this.productUseCase})
    : super(HomePageInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategoriesEvent);
    on<SelectedCategoryEvent>(_onSelectCategory);
    on<LoadProductEvent>(_onLoadProductEvent);
    on<SearchProductEvent>(_onSearchProduct);
  }

  Future<void> _onLoadCategoriesEvent(
    LoadCategoriesEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(HomePageLoading());

    try {
      final categoryList = await categoryUseCase();
      emit(
        HomePageCategoryLoaded(
          categoryList,
          categoryList.isNotEmpty ? categoryList.first : null,
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel &&
          e.error is UnauthorizedException) {
        return;
      }

      emit(HomePageFailure(mapDioError(e)));
    } catch (e) {
      emit(const HomePageFailure(UnknownException()));
    }
  }

  void _onSelectCategory(
    SelectedCategoryEvent event,
    Emitter<HomePageState> emit,
  ) {
    if (state is HomePageCategoryLoaded) {
      final currentState = state as HomePageCategoryLoaded;
      // If already selected, do nothing
      if (currentState.selectedCategory?.id == event.category.id) return;
      emit(HomePageCategoryLoaded(currentState.categories, event.category));

      if (event.loadProducts) {
        add(LoadProductEvent(categoryId: event.category.id));
      }
    }
  }

  Future<void> _onLoadProductEvent(
    LoadProductEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(HomePageProductLoading());

    try {
      final productList = await productUseCase(categoryId: event.categoryId);
      emit(HomePageProductLoaded(productList));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel &&
          e.error is UnauthorizedException) {
        return;
      }

      emit(HomePageFailure(mapDioError(e)));
    } catch (e) {
      emit(const HomePageFailure(UnknownException()));
    }
  }

  void _onSearchProduct(SearchProductEvent event, Emitter<HomePageState> emit) {
    if (state is HomePageProductLoaded) {
      final currentState = state as HomePageProductLoaded;
      final filtered = event.query.isEmpty
          ? [...currentState.productList]
          : currentState.productList.where((product) {
              return product.title?.toLowerCase().contains(
                    event.query.toLowerCase(),
                  ) ??
                  false;
            }).toList();

      emit(
        HomePageProductLoaded(currentState.productList, event.query, filtered),
      );
    }
  }
}
