import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../feature/models/category_model.dart';
import '../../../../models/product_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class HomePageViewModel {
  bool _hasAutoSelected = false;
  bool isCategoryLoading = false;
  bool isProductLoading = false;
  String? categoryError;
  String? productError;

  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  List<ProductModel> productList = [];

  // 🔍 Search-related
  String searchQuery = '';
  List<ProductModel> filteredProductList = [];
  Timer? _debounce;

  List<ProductModel> get visibleProducts {
    return searchQuery.isEmpty ? productList : filteredProductList;
  }

  void loadCategories(BuildContext context) {
    isCategoryLoading = true;
    context.read<HomePageBloc>().add(LoadCategoriesEvent());
  }

  String get noProductMessage {
    if (searchQuery.isNotEmpty) {
      return 'No products match your search.';
    }
    return 'No products available.';
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
      filteredProductList = state.filteredList;
      searchQuery = state.searchQuery;
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

  void onSearchChanged(BuildContext context, String query) {
    searchQuery = query;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<HomePageBloc>().add(SearchProductEvent(query));
    });
  }

  void dispose() {
    _debounce?.cancel();
  }
}
