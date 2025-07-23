import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/domain/repository/cart_repository.dart';
import 'package:dio/dio.dart';

class CartRepositoriesImpl implements CartRepository {
  final Dio _dio;

  CartRepositoriesImpl(this._dio);

  @override
  Future<String> addItemsToCart({
    required String user,
    required int quantity,
    required String productId,
  }) async {
    final response = await _dio.post(
      Environment.addItemsToCart,
      options: Options(headers: Environment.defaultHeaders),
      data: {'user': user, 'quantity': quantity, 'productId': productId},
    );

    final id = response.data['result']['id'];
    return id;
  }
}
