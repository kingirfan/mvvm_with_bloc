part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddItemsToCart extends CartEvent {
  final String user;
  final int quantity;
  final String productId;

  const AddItemsToCart({
    required this.user,
    required this.quantity,
    required this.productId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [user, quantity, productId];
}
