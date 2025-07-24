import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/cart_model.dart';

class CartViewModel {
  bool isCartLoading = false;
  List<CartModel> cartList = [];
  String? cartError;

  void loadCartList(BuildContext context) {
    isCartLoading = true;
    cartError = null;
    context.read<CartBloc>().add(GetAllCartItemsRequested());
  }

  void handleState(BuildContext context, CartState state) {
    isCartLoading = state.isCartLoading;
    cartList = state.cartList;
    cartError = state.cartError.isEmpty ? null : state.cartError;
  }

  bool get hasError => cartError != null && cartError!.isNotEmpty;

  String get emptyCartMessage =>
      hasError ? 'Failed to load cart: $cartError' : 'Your cart is empty.';
}
