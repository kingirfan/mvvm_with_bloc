import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/usecase/category_usecase.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/exceptions/app_exception.dart';
import '../../../../../core/utils/exceptions/exception_mapper.dart';
import '../../../../models/category_model.dart';
import 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomePageState> {
  final CategoryUseCase categoryUseCase;

  HomeBloc({required this.categoryUseCase}) : super(HomePageInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategoriesEvent);
  }

  Future<void> _onLoadCategoriesEvent(
    LoadCategoriesEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(HomePageLoading());

    try {
      await categoryUseCase();
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
}
