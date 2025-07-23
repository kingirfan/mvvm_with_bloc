import 'package:bloc/bloc.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/app_exception.dart';
import 'package:bloc_with_mvvm/core/utils/exceptions/exception_mapper.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/usecase/cart_usecase.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartUseCase cartUseCase;

  CartBloc({required this.cartUseCase}) : super(CartInitial()) {
    on<AddItemsToCart>(_onAddItemToCart);
  }

  Future<void> _onAddItemToCart(
    AddItemsToCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final id = await cartUseCase(
        user: event.user,
        quantity: event.quantity,
        productId: event.productId,
      );
      emit(CartSuccess(id: id));
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
}
