import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../feature/models/category_model.dart';
import '../../domain/usecase/category_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

/*class HomePageViewModel {
  List<CategoryModel> categories = [];
  bool isLoading = false;
  String? error;

  CategoryModel? currentCategory;
  var selectedCategory;

  void loadCategories(BuildContext context) {
    final bloc = BlocProvider.of<HomePageBloc>(context);
    bloc.add(LoadCategoriesEvent());
  }

  void handleState(HomePageState state) {
    if (state is HomePageLoading) {
      isLoading = true;
      error = null;
    } else if (state is HomePageCategoryLoaded) {
      isLoading = false;
      categories = state.categories;
      selectedCategory = state.selectedCategory;

      error = null;
    } else if (state is HomePageFailure) {
      isLoading = false;
      error = state.error.message;
    }
  }

  void selectCategory(CategoryModel category) {
    // If already selected, do nothing
    if (currentCategory?.id == category.id) return;

    currentCategory = category;

    // If you later want to fetch items based on selection:
    // if (category.items.isEmpty) {
    //   fetchItemsForCategory(category);
    // }
  }

}*/

class HomePageViewModel {
  bool _hasAutoSelected = false;

  void loadCategories(BuildContext context) {
    context.read<HomePageBloc>().add(LoadCategoriesEvent());
  }

  void handleState(BuildContext context, HomePageState state) {
    if (state is HomePageCategoryLoaded && !_hasAutoSelected) {
      final firstCategory = state.categories.firstOrNull;
      if (firstCategory != null) {
        _hasAutoSelected = true;
        context.read<HomePageBloc>().add(SelectedCategoryEvent(firstCategory));
      }
    }
  }

  void onCategorySelected(BuildContext context, CategoryModel category) {
    context.read<HomePageBloc>().add(SelectedCategoryEvent(category));
  }
}
