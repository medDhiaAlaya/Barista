import 'package:barista/models/category.dart';
import 'package:barista/models/product.dart';
import 'package:barista/models/shopping_cart.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/cart/shopping_cart.dart';
import 'package:barista/presentation/product/product.dart';
import 'package:barista/presentation/products/bloc/products_bloc.dart';
import 'package:barista/presentation/products/widgets/swipe_widget.dart';
import 'package:barista/presentation/products/widgets/swiper_header_widget.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_shimmer.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:barista/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatefulWidget {
  final Category category;
  const ProductsScreen({super.key, required this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  ValueNotifier<ProductWithDirection> productNotifier =
      ValueNotifier<ProductWithDirection>(ProductWithDirection());
  int currentIndex = 0;
  int quantity = 0;
  @override
  void initState() {
    ProductsBloc.get(context).add(
      ProductsGetProductsEvent(
        categoryId: widget.category.id,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingCartScreen(),
                ),
              );
            },
            icon: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
              listener: (context, state) {
                bool isItemExists = ShoppingCartBloc.get(context)
                    .shoppingCart
                    .items
                    .any((item) =>
                        item.product.id == productNotifier.value.product?.id);
                if (isItemExists) {
                  quantity = ShoppingCartBloc.get(context)
                      .shoppingCart
                      .items
                      .singleWhere((item) =>
                          item.product.id == productNotifier.value.product?.id)
                      .quantity;
                  setState(() {});
                }
              },
              builder: (context, state) {
                return Badge(
                  label: DefaultText(
                    text: ShoppingCartBloc.get(context)
                        .shoppingCart
                        .items
                        .length
                        .toString(),
                    textColor: Colors.white,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsSuccessState) {
            return Builder(
              builder: (context) {
                if (state.products.isEmpty) {
                  return const Center(
                    child: DefaultText(
                      text: 'No products found!',
                    ),
                  );
                } else if (state.products.length == 1) {
                  return Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: state.products[0],
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: state.products[0].id,
                          child: imageLoader(state.products[0].banner),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: SwiperHeaderWidget(
                          modelNotifier: productNotifier,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      SwiperWidget(
                        products: state.products,
                        onIndexChanged: (value) {
                          productNotifier.value = value;
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: SwiperHeaderWidget(
                          modelNotifier: productNotifier,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      kPrimaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (quantity > 0) {
                                      bool isItemExists =
                                          ShoppingCartBloc.get(context)
                                              .shoppingCart
                                              .items
                                              .any(
                                                (item) =>
                                                    item.product.id ==
                                                    productNotifier
                                                        .value.product?.id,
                                              );
                                      if (isItemExists) {
                                        ShoppingCartBloc.get(context).add(
                                          ShoppingCartUpdateItemEvent(
                                            shoppingCartItem:
                                                ShoppingCartBloc.get(context)
                                                    .shoppingCart
                                                    .items
                                                    .singleWhere(
                                                      (item) =>
                                                          item.product.id ==
                                                          productNotifier.value
                                                              .product?.id,
                                                    ),
                                            quantity: quantity,
                                          ),
                                        );
                                        showToast("Product updated", false);
                                      } else {
                                        ShoppingCartBloc.get(context).add(
                                          ShoppingCartAddItemEvent(
                                            shoppingCartItem: ShoppingCartItem(
                                              product: productNotifier
                                                  .value.product!,
                                              quantity: quantity,
                                              totalPrice: productNotifier
                                                      .value.product!.price *
                                                  quantity,
                                            ),
                                          ),
                                        );
                                        showToast("Product added", false);
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: DefaultText(
                                      textSize: 16.0,
                                      text: ShoppingCartBloc.get(context)
                                              .shoppingCart
                                              .items
                                              .any(
                                                (item) =>
                                                    item.product.id ==
                                                    productNotifier
                                                        .value.product?.id,
                                              )
                                          ? 'Update'
                                          : 'Add To Cart',
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: quantity > 0
                                            ? () {
                                                setState(() {
                                                  quantity -= 1;
                                                });
                                              }
                                            : null,
                                      ),
                                      DefaultText(
                                        textSize: 20,
                                        text: quantity.toString(),
                                        weight: FontWeight.w400,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            quantity += 1;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          } else if (state is ProductsErrorState) {
            return errorWidget(
              state.message,
              () {
                ProductsBloc.get(context).add(
                  ProductsGetProductsEvent(
                    categoryId: widget.category.id,
                  ),
                );
              },
            );
          } else {
            return loadingShimmer();
          }
        },
      ),
    );
  }

  Widget productItem(Product product) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              product: product,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 120,
              width: 130,
              child: imageLoader(
                product.banner,
              ),
            ),
            DefaultText(
              text: product.name,
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
