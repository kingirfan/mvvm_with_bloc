import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/view_models/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/custom_colors.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/cart_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartViewModel cartViewModel = CartViewModel();

  @override
  void initState() {
    super.initState();
    cartViewModel.loadCart(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          cartViewModel.handleState(state);

          if (cartViewModel.hasAddError) {
            print(cartViewModel.emptyAddCartMessage);
          } else {
            print('Add to the Cart Successfully');
          }

          if (cartViewModel.hasUpdateError) {
            print(cartViewModel.emptyUpdateCartMessage);
          } else {
            print('Updated Cart Successfully');
          }
        },
        builder: (context, state) {
          if (cartViewModel.isAddLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // if (cartViewModel.isUpdateLoading) {
          //   return const Center(child: CircularProgressIndicator());
          // }

          if (cartViewModel.isCartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartViewModel.hasError) {
            return Text(cartViewModel.emptyCartMessage);
          }

          if (cartViewModel.cartList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    color: CustomColors.customSwatchColor,
                    size: 40,
                  ),
                  const Text('No Items in the cart'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: cartViewModel.cartList.length,
            itemBuilder: (context, index) {
              return CartTile(
                cartItemModel: cartViewModel.cartList[index],
                //remove: removeFromCart,
              );
            },
          );
        },
      ),
    );
  }
}
