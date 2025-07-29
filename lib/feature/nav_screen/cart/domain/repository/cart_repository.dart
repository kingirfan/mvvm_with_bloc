import 'package:bloc_with_mvvm/feature/models/cart_model.dart';

abstract class CartRepository {
  Future<String> addItemsToCart({
    required String productId,
  });

  Future<List<CartModel>> getAllCarts();

  Future<int?> updateCartQuantity({required String cartItemId, required int quantity});
}
