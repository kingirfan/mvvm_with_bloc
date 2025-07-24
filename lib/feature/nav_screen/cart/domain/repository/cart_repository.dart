import 'package:bloc_with_mvvm/feature/models/cart_model.dart';

abstract class CartRepository {
  Future<String> addItemsToCart({
    required int quantity,
    required String productId,
  });

  Future<List<CartModel>> getAllCarts();
}
