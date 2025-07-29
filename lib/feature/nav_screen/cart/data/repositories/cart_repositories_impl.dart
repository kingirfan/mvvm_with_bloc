import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/feature/models/cart_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/repository/cart_repository.dart';
import 'package:dio/dio.dart';

import '../../../../../core/utils/token_storage.dart';
import '../../../../models/category_model.dart';

class CartRepositoriesImpl implements CartRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  CartRepositoriesImpl(this._dio, this._tokenStorage);

  @override
  Future<String> addItemsToCart({required String productId}) async {
    final userId = await _tokenStorage.getUserId();
    print('userId : $userId');
    final response = await _dio.post(
      Environment.addItemsToCart,
      options: Options(headers: Environment.defaultHeaders),
      data: {'user': userId, 'quantity': 1, 'productId': productId},
    );

    final id = response.data['result']['id'];
    return id;
  }

  @override
  Future<List<CartModel>> getAllCarts() async {
    final userId = await _tokenStorage.getUserId();
    print('userId : $userId');
    final response = await _dio.post(
      Environment.getAllItemsFromCart,
      options: Options(headers: Environment.defaultHeaders),
      data: {'user': userId},
    );

    final List data = response.data['result'];

    return data.map((e) => CartModel.fromJson(e)).toList();
  }

  @override
  Future<int?> updateCartQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    final response = await _dio.post(
      Environment.updateCartItems,
      options: Options(headers: Environment.defaultHeaders),
      data: {'cartItemId': cartItemId, 'quantity': quantity},
    );

    if (response.statusCode == 200) {
      return 200;
    } else {
      throw Exception("Failed to update quantity");
    }

  }
}
