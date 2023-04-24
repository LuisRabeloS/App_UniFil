import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja/src/config/custom_colors.dart';
import 'package:loja/src/models/cart_item_model.dart';
import 'package:loja/src/pages/cart/controller/cart_controller.dart';
import 'package:loja/src/services/utils_services.dart';
import 'package:loja/src/config/app_data.dart' as appData;

import '../common_widgets/payment_dialog.dart';
import 'view/components/cart_tile.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilsServices utilsServices = UtilsServices();
  final cartController = Get.find<CartController>();

  double cartTotalPrice() {
    /*double total = 0;
    for (var item in appData.cartItems) {
      total += item.totalPrice();
    } */
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Expanded(child: GetBuilder<CartController>(builder: (controller) {
            if (controller.cartItems.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 40,
                    color: CustomColors.customSwatchColor,
                  ),
                  const Text('Carrinho está vazio'),
                ],
              );
            }
            return ListView.builder(
              itemCount: controller.cartItems.length,
              itemBuilder: (_, index) {
                return CartTile(
                  cartItem: controller.cartItems[index],
                );
              },
            );
          })),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total geral',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                GetBuilder<CartController>(builder: (controller) {
                  return Text(
                    utilsServices.priceToCurrency(controller.cartTotalPrice()),
                    style: TextStyle(
                      fontSize: 23,
                      color: CustomColors.customSwatchColor,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                SizedBox(
                  height: 50,
                  child: GetBuilder<CartController>(builder: (controller) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: controller.isCheckoutLoading
                          ? null
                          : () async {
                              bool? result = await showOrderConfirmation();
                              if (result ?? false) {
                                cartController.checkoutCart();
                              } else {
                                utilsServices.showToast(
                                    message: 'Pedido não confirmado');
                              }
                            },
                      child: controller.isCheckoutLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Concluir pedido',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Confirmação'),
          content: const Text('Deseja concluir o pedido?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            )
          ],
        );
      },
    );
  }
}
