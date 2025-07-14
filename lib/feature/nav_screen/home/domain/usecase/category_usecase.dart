import 'package:bloc_with_mvvm/feature/models/category_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/home/domain/repository/home_repository.dart';

class CategoryUseCase {
  CategoryUseCase(this.homeRepository);

  final HomeRepository homeRepository;

  Future<List<CategoryModel>> call() {
    return homeRepository.getCategories();
  }
}
