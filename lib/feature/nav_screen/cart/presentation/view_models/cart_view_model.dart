import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/cart_model.dart';

class CartViewModel {
  bool isCartLoading = false;
  bool isAddLoading = false;
  bool isUpdateLoading = false;
  List<CartModel> cartList = [];
  String? cartError;
  String? addError;
  String? updateError;

  bool get hasError => cartError != null && cartError!.isNotEmpty;

  bool get hasAddError => addError != null && addError!.isNotEmpty;

  bool get hasUpdateError => updateError != null && updateError!.isNotEmpty;

  String get emptyCartMessage =>
      hasError ? 'Failed to load cart: $cartError' : 'Your cart is empty.';

  String get emptyAddCartMessage =>
      hasAddError ? 'Failed to add item: $addError' : 'Your cart is empty.';

  String get emptyUpdateCartMessage => hasUpdateError
      ? 'Failed to update item: $updateError'
      : 'Your cart is empty.';

  void loadCart(BuildContext context) {
    // For initial or manual load
    context.read<CartBloc>().add(GetAllCartItemsRequested());
  }

  void addToCart(BuildContext context, ProductModel productModel) {
    final latestState = context.read<CartBloc>().state;
    handleState(latestState);
    int itemIndex = getItemIndex(productModel);

    if (itemIndex >= 0) {
      final product = cartList[itemIndex];
      changeItemQuantity(context, product, product.quantity! + 1);
    } else {
      context.read<CartBloc>().add(
        AddItemsRequested(productId: productModel.id!),
      );
    }
  }

  void changeItemQuantity(
    BuildContext context,
    CartModel cartModel,
    int quantity,
  ) {
    context.read<CartBloc>().add(
      UpdateQuantityRequested(cartItemId: cartModel.id!, quantity: quantity),
    );
  }

  void handleState(CartState state) {
    isCartLoading = state.isCartLoading;
    isAddLoading = state.addCartLoading;
    isUpdateLoading = state.updateCartLoading;

    cartList = state.cartList;

    cartError = (state.cartError?.isEmpty ?? true) ? null : state.cartError;
    addError = (state.addError?.isEmpty ?? true) ? null : state.addError;
    updateError = (state.updateError?.isEmpty ?? true)
        ? null
        : state.updateError;
  }

  int getItemIndex(ProductModel productModel) {
    return cartList.indexWhere(
      (item) => item.productModel?.id == productModel.id,
    );
  }

  double cartTotalPrice() {
    return cartList.fold(0, (total, element) => total + element.totalPrice());
  }
}
