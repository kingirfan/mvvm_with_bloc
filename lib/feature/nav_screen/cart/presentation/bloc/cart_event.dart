part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddItemsRequested extends CartEvent {
  final String productId;

  const AddItemsRequested({required this.productId});

  @override
  // TODO: implement props
  List<Object?> get props => [productId];
}

class GetAllCartItemsRequested extends CartEvent {}

class UpdateQuantityRequested extends CartEvent {
  final String cartItemId;
  final int quantity;

  const UpdateQuantityRequested({required this.cartItemId, required this.quantity});
}
