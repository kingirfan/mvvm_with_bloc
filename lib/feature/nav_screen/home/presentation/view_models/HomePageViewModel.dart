import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../feature/models/category_model.dart';
import '../../domain/usecase/category_usecase.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';


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
