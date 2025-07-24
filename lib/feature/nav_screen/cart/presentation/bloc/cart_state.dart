part of 'cart_bloc.dart';

// abstract class CartState extends Equatable {
//   const CartState();
//
//   @override
//   List<Object> get props => [];
// }
//
// final class CartInitial extends CartState {}
//
// final class CartLoading extends CartState {}
//
// final class CartLoaded extends CartState {
//   final List<CartModel> cartModelList;
//
//   const CartLoaded({required this.cartModelList});
// }
//
// final class CartSuccess extends CartState {
//   final String id;
//
//   const CartSuccess({required this.id});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [id];
// }
//
// final class CartFailure extends CartState {
//   final AppException error;
//
//   const CartFailure({required this.error});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => [error];
// }

class CartState {
  final bool isCartLoading;
  final List<CartModel> cartList;
  final String cartError;

  const CartState({
    this.isCartLoading = false,
    required this.cartList,
    required this.cartError,
  });

  CartState copyWith({
    bool? isCartLoading,
    List<CartModel>? cartList,
    String? cartError,
  }) {
    return CartState(
      isCartLoading: isCartLoading ?? this.isCartLoading,
      cartList: cartList ?? this.cartList,
      cartError: cartError ?? this.cartError,
    );
  }
}
