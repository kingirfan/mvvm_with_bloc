import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
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

  HomePageBloc({required this.categoryUseCase}) : super(HomePageInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategoriesEvent);
    on<SelectedCategoryEvent>(_onSelectCategory);

  }

  Future<void> _onLoadCategoriesEvent(
    LoadCategoriesEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(HomePageLoading());

    try {
      final categoryList = await categoryUseCase();
      emit(HomePageCategoryLoaded(categoryList, categoryList.isNotEmpty ? categoryList.first : null,));
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

      emit(HomePageCategoryLoaded(currentState.categories, event.category));
    }
  }
}
