import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loja/src/config/custom_colors.dart';
import 'package:loja/src/config/app_data.dart' as appData;
import 'package:loja/src/pages/base/controller/navigation_controller.dart';
import 'package:loja/src/pages/cart/controller/cart_controller.dart';
import 'package:loja/src/pages/home/controller/home_controller.dart';
import 'package:loja/src/pages/home/view/components/item_tile.dart';
import 'package:loja/src/services/utils_services.dart';
import 'package:loja/src/pages/common_widgets/custom_shimmer.dart';

import '../../common_widgets/app_name_widget.dart';
import 'components/category_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();
  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();
  late Function(GlobalKey) runAddToCartAnimation;
  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  final UtilsServices utilsServices = UtilsServices();
  //final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
            ),
            child: GetBuilder<CartController>(builder: (controller) {
              return GestureDetector(
                onTap: () {
                  navigationController.navigatePageView(NavigationTabs.cart);
                },
                child: Badge(
                  badgeColor: CustomColors.customContrastColor,
                  badgeContent: Text(
                    controller.cartItems.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: AddToCartIcon(
                    key: globalKeyCartItems,
                    icon: Icon(
                      Icons.shopping_cart,
                      color: CustomColors.customSwatchColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),

      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
          runAddToCartAnimation = addToCartAnimationMethod;
        },
        child: Column(
          children: [
            //Campo de pesquisa
            GetBuilder<HomeController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Busque aqui...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withAlpha(450),
                        size: 21,
                      ),
                      suffixIcon: controller.searchTitle.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                controller.searchTitle.value = '';
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                color: CustomColors.customContrastColor,
                                size: 21,
                              ))
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            //Categorias
            GetBuilder<HomeController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.only(left: 25),
                height: 40,
                child: !controller.isCategoryLoading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return CategoryTile(
                            onPressed: () {
                              controller.selectCategory(
                                  controller.allCategories[index]);
                            },
                            category: controller.allCategories[index].title,
                            isSelected: controller.allCategories[index] ==
                                controller.currentCategory,
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 10),
                        itemCount: controller.allCategories.length,
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          10,
                          (index) => Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 12),
                            child: CustomShimmer(
                              height: 20,
                              width: 80,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
              );
            }),
            //Grid
            GetBuilder<HomeController>(builder: (controller) {
              return Expanded(
                child: !controller.isProductLoading
                    ? Visibility(
                        visible: (controller.currentCategory?.items ?? [])
                            .isNotEmpty,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 9 / 11.5,
                          ),
                          itemCount: controller.allProducts.length,
                          itemBuilder: (_, index) {
                            if (((index + 1) ==
                                    controller.allProducts.length) &&
                                !controller.isLastPage) {
                              controller.loadMoreProducts();
                            }
                            return ItemTile(
                              item: controller.allProducts[index],
                              cartAnimationMethod: itemSelectedCartAnimations,
                            );
                          },
                        ),
                        replacement: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 40,
                              color: CustomColors.customSwatchColor,
                            ),
                            const Text('Não há itens para apresentar'),
                          ],
                        ),
                      )
                    : GridView.count(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 9 / 11.5,
                        children: List.generate(
                          10,
                          (index) => CustomShimmer(
                            height: double.infinity,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
