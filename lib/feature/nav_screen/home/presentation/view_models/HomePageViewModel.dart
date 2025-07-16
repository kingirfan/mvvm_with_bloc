import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../feature/models/category_model.dart';
import '../../../../models/product_model.dart';
import '../../domain/usecase/category_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

/*class HomePageViewModel {
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
}*/

class HomePageViewModel {
  bool _hasAutoSelected = false;
  bool isCategoryLoading = false;
  bool isProductLoading = false;
  String? categoryError;
  String? productError;

  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  List<ProductModel> productList = [];

  void loadCategories(BuildContext context) {
    isCategoryLoading = true;
    context.read<HomePageBloc>().add(LoadCategoriesEvent());
  }

  void handleState(BuildContext context, HomePageState state) {
    // Reset errors
    categoryError = null;
    productError = null;

    if (state is HomePageLoading) {
      // This loader indicates only category loading
      isCategoryLoading = true;
    }

    if (state is HomePageCategoryLoaded) {
      isCategoryLoading = false;
      categories = state.categories;
      selectedCategory = state.selectedCategory;

      if (!_hasAutoSelected && selectedCategory != null) {
        _hasAutoSelected = true;
        onCategorySelected(context, selectedCategory!); // auto-select first
      }
    }

    if (state is HomePageProductLoading) {
      isProductLoading = true;
      productList = [];
    }

    if (state is HomePageProductLoaded) {
      isProductLoading = false;
      productList = state.productList;
    }

    if (state is HomePageFailure) {
      isCategoryLoading = false;
      isProductLoading = false;
      productError = state.error.message;
    }
  }

  void onCategorySelected(BuildContext context, CategoryModel category) {
    selectedCategory = category;
    isProductLoading = true;
    productError = null;
    productList = [];

    context.read<HomePageBloc>().add(
      SelectedCategoryEvent(category, loadProducts: true),
    );
    context.read<HomePageBloc>().add(LoadProductEvent(categoryId: category.id));
  }
}
