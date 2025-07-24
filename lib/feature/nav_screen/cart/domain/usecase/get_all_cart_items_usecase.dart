import 'package:bloc_with_mvvm/feature/models/cart_model.dart';

import '../repository/cart_repository.dart';

class GetAllCartItemsUseCase {
  GetAllCartItemsUseCase(this.cartRepository);

  final CartRepository cartRepository;

  Future<List<CartModel>> call() {
    return cartRepository.getAllCarts();
  }
}
