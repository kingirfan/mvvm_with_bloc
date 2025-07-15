

import 'package:equatable/equatable.dart';

import '../../../../models/category_model.dart';

abstract class HomeEvent extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends HomeEvent {}

class SelectedCategoryEvent extends HomeEvent {
  final CategoryModel category;

  SelectedCategoryEvent(this.category);

  @override
  // TODO: implement props
  List<Object?> get props => [category];

}


