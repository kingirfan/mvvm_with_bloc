import 'package:bloc_with_mvvm/feature/models/product_model.dart';

import '../../../../models/category_model.dart';

abstract class HomeRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getAllProducts(String categoryId);
}
