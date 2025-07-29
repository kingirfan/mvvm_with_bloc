import '../../../../models/cart_model.dart';
import '../repository/cart_repository.dart';

class UpdateQuantityUseCase {
  UpdateQuantityUseCase(this.cartRepository);

  final CartRepository cartRepository;

  Future<int?> call({required String cartItemId, required int quantity}) {
    return cartRepository.updateCartQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }
}
