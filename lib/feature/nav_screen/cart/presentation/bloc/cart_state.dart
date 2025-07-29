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
  final bool addCartLoading;
  final bool updateCartLoading;
  final List<CartModel> cartList;
  final String? cartError;
  final String? addError;
  final String? updateError;

  const CartState({
    this.isCartLoading = false,
    this.addCartLoading = false,
    this.updateCartLoading = false,
    required this.cartList,
    this.cartError,
    this.addError,
    this.updateError,
  });

  CartState copyWith({
    bool? isCartLoading,
    bool? addCartLoading,
    bool? updateCartLoading,
    List<CartModel>? cartList,
    String? cartError,
    String? addError,
    String? updateError,
  }) {
    return CartState(
      isCartLoading: isCartLoading ?? this.isCartLoading,
      addCartLoading: addCartLoading ?? this.addCartLoading,
      updateCartLoading: updateCartLoading ?? this.updateCartLoading,
      cartList: cartList ?? this.cartList,
      cartError: cartError ?? this.cartError,
      addError: addError,
      updateError: updateError,
    );
  }
}
