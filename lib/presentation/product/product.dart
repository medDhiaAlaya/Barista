import 'package:barista/models/product.dart';
import 'package:barista/models/shopping_cart.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/cart/shopping_cart.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:barista/shared/styles/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int currentIndex = 0;
  int quantity = 0;
  @override
  void initState() {
    bool isItemExists = ShoppingCartBloc.get(context)
        .shoppingCart
        .items
        .any((item) => item.product.id == widget.product.id);
    if (isItemExists) {
      quantity = ShoppingCartBloc.get(context)
          .shoppingCart
          .items
          .singleWhere((item) => item.product.id == widget.product.id)
          .quantity;
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(widget.product.name),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShoppingCartScreen(),
                    ),
                  );
                },
                icon: Badge(
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
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                slider(widget.product.images, widget.product.id),
                const SizedBox(height: 16.0),
                DefaultText(
                  text: widget.product.name,
                  textSize: 24.0,
                  weight: FontWeight.bold,
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultText(
                    text: "description : ${widget.product.description}",
                    textSize: 16.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                DefaultText(
                  text: '${widget.product.price} DT',
                  textSize: 20.0,
                  weight: FontWeight.bold,
                  textColor: Colors.green,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          kPrimaryColor,
                        ),
                      ),
                      onPressed: () {
                        if (quantity > 0) {
                          bool isItemExists = ShoppingCartBloc.get(context)
                              .shoppingCart
                              .items
                              .any(
                                (item) => item.product.id == widget.product.id,
                              );
                          if (isItemExists) {
                            ShoppingCartBloc.get(context).add(
                              ShoppingCartUpdateItemEvent(
                                shoppingCartItem: ShoppingCartBloc.get(context)
                                    .shoppingCart
                                    .items
                                    .singleWhere(
                                      (item) =>
                                          item.product.id == widget.product.id,
                                    ),
                                quantity: quantity,
                              ),
                            );
                            showToast("Product updated", false);
                          } else {
                            ShoppingCartBloc.get(context).add(
                              ShoppingCartAddItemEvent(
                                shoppingCartItem: ShoppingCartItem(
                                  product: widget.product,
                                  quantity: quantity,
                                  totalPrice: widget.product.price * quantity,
                                ),
                              ),
                            );
                            showToast("Product added", false);
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DefaultText(
                          textSize: 16.0,
                          text: ShoppingCartBloc.get(context)
                                  .shoppingCart
                                  .items
                                  .any(
                                    (item) =>
                                        item.product.id == widget.product.id,
                                  )
                              ? 'Update'
                              : 'Add To Cart',
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }

  Widget slider(List<String> images, String id) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: CarouselSlider(
            items: List.generate(
              images.length,
              (index) {
                if (index == 0) {
                  return Hero(
                    tag: id,
                    child: Center(
                      child: SizedBox(
                        height: 250,
                        width: size.width - 10,
                        child: imageLoader(
                          images[index],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      height: 250,
                      width: size.width - 10,
                      child: imageLoader(
                        images[index],
                      ),
                    ),
                  );
                }
              },
            ),
            options: CarouselOptions(
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSmoothIndicator(
            activeIndex: currentIndex,
            effect: const JumpingDotEffect(
              dotWidth: 7,
              dotHeight: 7,
              spacing: 10,
              dotColor: Color(0xFFD9D9D9),
              activeDotColor: Color(0xFFAF81EA),
            ),
            count: images.length,
          ),
        ),
      ],
    );
  }
}
