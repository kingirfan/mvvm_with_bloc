import 'package:bloc_with_mvvm/core/utils/utils_service.dart';
import 'package:bloc_with_mvvm/feature/models/cart_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/view_models/cart_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../common/quantity_button.dart';
import '../../../../../core/theme/custom_colors.dart';

class CartTile extends StatefulWidget {
  final CartModel cartItemModel;

  // final Function(CartItemModel) remove;

  const CartTile({
    super.key,
    required this.cartItemModel,
    // required this.remove,
  });

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  UtilsServices utilServices = UtilsServices();
  CartViewModel cartViewModel = CartViewModel();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.network(
          widget.cartItemModel.productModel!.picture!,
          height: 60,
          width: 60,
        ),
        title: Text(
          widget.cartItemModel.productModel!.title!,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: QuantityWidget(
          value: widget.cartItemModel.quantity!,
          suffixText: widget.cartItemModel.productModel!.unit!,
          result: (quantity) {
            CartViewModel cartViewModel = CartViewModel();
            cartViewModel.changeItemQuantity(context, widget.cartItemModel, quantity);
            print('quantity $quantity');
          },
          isRemovable: true,
        ),
        subtitle: Text(
          utilServices.priceToCurrency(widget.cartItemModel.totalPrice()),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CustomColors.customSwatchColor,
          ),
        ),
      ),
    );
  }
}
