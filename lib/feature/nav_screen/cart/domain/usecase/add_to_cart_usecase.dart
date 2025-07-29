import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/repository/cart_repository.dart';

class AddToCartUseCase {
  AddToCartUseCase(this.cartRepository);

  final CartRepository cartRepository;

  Future<String> call({required String productId}) {
    return cartRepository.addItemsToCart(
      productId: productId,
    );
  }
}
