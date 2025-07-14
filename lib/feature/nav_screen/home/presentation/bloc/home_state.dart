part of 'home_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object?> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageCategoryLoaded extends HomePageState {
  final List<CategoryModel> categories;
  final CategoryModel? selectedCategory;

  const HomePageCategoryLoaded(this.categories, this.selectedCategory);

  @override
  List<Object?> get props => [categories, selectedCategory];
}



class HomePageFailure extends HomePageState {
  final AppException error;

  const HomePageFailure(this.error);

  @override
  List<Object> get props => [error];
}
