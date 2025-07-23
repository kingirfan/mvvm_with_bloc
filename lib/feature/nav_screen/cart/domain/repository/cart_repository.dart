abstract class CartRepository {
  Future<String> addItemsToCart({
    required String user,
    required int quantity,
    required String productId,
  });
}
