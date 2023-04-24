import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loja/src/config/custom_colors.dart';
import 'package:loja/src/pages/base/controller/navigation_controller.dart';
import 'package:loja/src/pages/cart/controller/cart_controller.dart';
import 'package:loja/src/pages/common_widgets/quantity_widget.dart';
import 'package:loja/src/services/utils_services.dart';

import '../../models/item_model.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({
    Key? key,
    //required this.item,
  }) : super(key: key);

  final ItemModel item = Get.arguments;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final UtilsServices utilsServices = UtilsServices();

  int cartItemQuantity = 1;

  final cartController = Get.find<CartController>();
  final navigationController = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(230),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: Hero(
                      tag: widget.item.imgUrl,
                      child: Image.network(widget.item.imgUrl))),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        QuantityWidget(
                          suffixText: widget.item.unit,
                          value: cartItemQuantity,
                          result: (quantity) {
                            setState(() {
                              cartItemQuantity = quantity;
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      utilsServices.priceToCurrency(widget.item.price),
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.item.description,
                          style: const TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    //Botao
                    SizedBox(
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          Get.back();
                          cartController.addItemToCart(
                              item: widget.item, quantity: cartItemQuantity);
                          navigationController
                              .navigatePageView(NavigationTabs.cart);
                        },
                        label: const Text(
                          'Add ao carrinho',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          )
        ],
      ),
    );
  }
}
