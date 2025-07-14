import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../feature/models/category_model.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class HomePageViewModel {
  List<CategoryModel> categories = [];
  bool isLoading = false;
  String? error;

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
      error = null;
    } else if (state is HomePageFailure) {
      isLoading = false;
      error = state.error.message;
    }
  }
}
