import 'package:bloc_with_mvvm/feature/models/product_model.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/bloc/cart_bloc.dart';
import 'package:bloc_with_mvvm/feature/nav_screen/cart/presentation/view_models/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/custom_colors.dart';
import '../../../../../core/utils/utils_service.dart';

class ItemTile extends StatefulWidget {
  final ProductModel item;

  // final void Function(GlobalKey) cartAnimationMethod;

  const ItemTile({
    super.key,
    required this.item,
    // required this.cartAnimationMethod,
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final GlobalKey imageGk = GlobalKey();

  final UtilsServices utilsServices = UtilsServices();

  IconData tileIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() => tileIcon = Icons.check);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => tileIcon = Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Conteúdo
        GestureDetector(
          onTap: () {
            //Get.toNamed(PagesRoutes.productRoute, arguments: widget.item);
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagem
                  Expanded(
                    child: Hero(
                      tag: widget.item.picture ?? 'No Image found',
                      child: Image.network(
                        widget.item.picture ?? '',
                        key: imageGk,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                      ),
                    ),
                  ),

                  // Nome
                  Text(
                    widget.item.title ?? 'No tile found',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Preço - Unidade
                  Row(
                    children: [
                      Text(
                        utilsServices.priceToCurrency(widget.item.price ?? 0.0),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                      Text(
                        '/${widget.item.unit}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Botão add carrinho
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20),
            ),
            child: Material(
              child: BlocListener<CartBloc, CartState>(
                listener: (context, state) {

                },
                child: InkWell(
                  onTap: () {
                    switchIcon();
                    CartViewModel cartViewModel = CartViewModel();
                    cartViewModel.addToCart(context, widget.item);
                  },
                  child: Ink(
                    height: 40,
                    width: 35,
                    decoration: BoxDecoration(
                      color: CustomColors.customSwatchColor,
                    ),
                    child: Icon(tileIcon, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
