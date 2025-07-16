import 'package:bloc_with_mvvm/feature/models/product_model.dart';

import '../repository/home_repository.dart';

class ProductUseCase {
  ProductUseCase(this.homeRepository);

  final HomeRepository homeRepository;

  Future<List<ProductModel>> call({required String categoryId}) {
    return homeRepository.getAllProducts(categoryId);
  }
}
