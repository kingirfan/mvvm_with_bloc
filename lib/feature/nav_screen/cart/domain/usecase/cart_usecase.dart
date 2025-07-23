import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/repository/cart_repository.dart';

class CartUseCase {
  CartUseCase(this.cartRepository);

  final CartRepository cartRepository;

  Future<String> call({
    required String user,
    required int quantity,
    required String productId,
  }) {
    return cartRepository.addItemsToCart(
      user: user,
      quantity: quantity,
      productId: productId,
    );
  }
}
