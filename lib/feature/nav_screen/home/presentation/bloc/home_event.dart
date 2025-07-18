import 'package:equatable/equatable.dart';

import '../../../../models/category_model.dart';

abstract class HomeEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends HomeEvent {}

class SelectedCategoryEvent extends HomeEvent {
  final CategoryModel category;
  final bool loadProducts;

  SelectedCategoryEvent(this.category, {this.loadProducts = true});

  @override
  // TODO: implement props
  List<Object?> get props => [category];
}

class LoadProductEvent extends HomeEvent {
  final String categoryId;

  LoadProductEvent({required this.categoryId});

  @override
  // TODO: implement props
  List<Object?> get props => [categoryId];
}

class SearchProductEvent extends HomeEvent {
  final String query;

  SearchProductEvent(this.query);

  @override
  List<Object?> get props => [query];
}
