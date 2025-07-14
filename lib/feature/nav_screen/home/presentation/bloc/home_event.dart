

import '../../../../models/category_model.dart';

abstract class HomeEvent {}

class LoadCategoriesEvent extends HomeEvent {}

class SelectedCategoryEvent extends HomeEvent {
  final CategoryModel category;

  SelectedCategoryEvent(this.category);
}


