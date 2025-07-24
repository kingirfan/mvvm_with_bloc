part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddItemsToCart extends CartEvent {
  final int quantity;
  final String productId;

  const AddItemsToCart({required this.quantity, required this.productId});

  @override
  // TODO: implement props
  List<Object?> get props => [quantity, productId];
}

class GetAllCartItemsRequested extends CartEvent{}
