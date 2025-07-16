import 'package:bloc_with_mvvm/core/app/enviornment.dart';
import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/repository/home_repository.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.post(
      Environment.getAllCategory,
      options: Options(headers: Environment.defaultHeaders),
    );

    final List data = response.data['result'];

    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getAllProducts(String categoryId) async {
    final response = await _dio.post(
      Environment.getAllProducts,
      options: Options(headers: Environment.defaultHeaders),
      data: {'categoryId': categoryId},
    );

    final List data = response.data['result'];

    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
