import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:loja/src/config/app_data.dart' as appData;
import 'package:loja/src/pages/orders/controller/all_orders_controller.dart';
import 'package:loja/src/pages/orders/view/components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos'),
        ),
        body: GetBuilder<AllOrdersController>(builder: (controller) {
          return ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemBuilder: (_, index) {
                return OrderTile(
                  order: controller.allOrders[index],
                );
              },
              itemCount: controller.allOrders.length);
        }));
  }
}
