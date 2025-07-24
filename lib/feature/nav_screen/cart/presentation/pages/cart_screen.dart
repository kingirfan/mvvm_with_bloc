import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/view_models/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cart_bloc.dart';

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
    cartViewModel.loadCartList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          cartViewModel.handleState(context, state);

          if (cartViewModel.isCartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartViewModel.hasError) {
            return Text(cartViewModel.emptyCartMessage);
          }

          if (cartViewModel.cartList.isNotEmpty) {
            return Center(child: Text('${cartViewModel.cartList.length}', style: const TextStyle(color: Colors.white),));
          }

          return const Center(child: Text('Cart Page'));
        },
      ),
    );
  }
}
