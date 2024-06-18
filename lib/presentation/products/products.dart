import 'package:barista/models/category.dart';
import 'package:barista/models/product.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/cart/shopping_cart.dart';
import 'package:barista/presentation/product/product.dart';
import 'package:barista/presentation/products/bloc/products_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_shimmer.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatefulWidget {
  final Category category;
  const ProductsScreen({super.key, required this.category});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
            icon: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
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
            return RefreshIndicator(
              onRefresh: () async {
                ProductsBloc.get(context).add(
                  ProductsGetProductsEvent(
                    categoryId: widget.category.id,
                  ),
                );
              },
              child: Builder(
                builder: (context) {
                  if (state.products.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: DefaultText(
                            text: 'No products found!',
                          ),
                        )
                      ],
                    );
                  } else {
                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return productItem(state.products[index]);
                      },
                    );
                  }
                },
              ),
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
