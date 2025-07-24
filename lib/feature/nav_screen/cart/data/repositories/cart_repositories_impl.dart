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
  Future<String> addItemsToCart({
    required int quantity,
    required String productId,
  }) async {
    final userId = await _tokenStorage.getUserId();
    print('userId $userId');
    final response = await _dio.post(
      Environment.addItemsToCart,
      options: Options(headers: Environment.defaultHeaders),
      data: {'user': userId, 'quantity': quantity, 'productId': productId},
    );

    final id = response.data['result']['id'];
    return id;
  }

  @override
  Future<List<CartModel>> getAllCarts() async {
    final userId = await _tokenStorage.getUserId();
    final response = await _dio.post(
      Environment.getAllItemsFromCart,
      options: Options(headers: Environment.defaultHeaders),
      data: {'user': userId},
    );

    final List data = response.data['result'];

    return data.map((e) => CartModel.fromJson(e)).toList();
  }
}
