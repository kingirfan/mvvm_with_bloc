import 'package:bloc/bloc.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/exception_mapper.dart';
import 'package:bloc_with_mvvm/feature/models/cart_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/usecase/add_to_cart_usecase.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecase/get_all_cart_items_usecase.dart';

part 'cart_event.dart';

part 'cart_state.dart';

/*class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase cartUseCase;
  final GetAllCartItemsUseCase getAllCartItemsUseCase;

  CartBloc({required this.cartUseCase, required this.getAllCartItemsUseCase})
    : super(CartInitial()) {
    // on<AddItemsToCart>(_onAddItemToCart);
    on<GetAllCartItemsRequested>(_onGetAllCartItemsRequested);
  }



  Future<void> _onGetAllCartItemsRequested(
    GetAllCartItemsRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final cartList = await getAllCartItemsUseCase.call();
      emit(CartLoaded(cartModelList: cartList));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel &&
          e.error is UnauthorizedException) {
        return;
      }
      emit(CartFailure(error: mapDioError(e)));
    } catch (e) {
      emit(const CartFailure(error: UnknownException()));
    }
  }
}*/

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase cartUseCase;
  final GetAllCartItemsUseCase getAllCartItemsUseCase;

  CartBloc({required this.cartUseCase, required this.getAllCartItemsUseCase})
    : super(const CartState(cartList: [], cartError: '')) {
    on<GetAllCartItemsRequested>(_onGetAllCartItemsRequested);
    // Add other event handlers here
  }

  Future<void> _onGetAllCartItemsRequested(
    GetAllCartItemsRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isCartLoading: true, cartError: ''));
    try {
      final cartList = await getAllCartItemsUseCase.call();
      emit(
        state.copyWith(isCartLoading: false, cartList: cartList, cartError: ''),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel &&
          e.error is UnauthorizedException) {
        return;
      }
      emit(
        state.copyWith(isCartLoading: false, cartError: mapDioError(e).message),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isCartLoading: false,
          cartError: 'Unknown error occurred',
        ),
      );
    }
  }
}
