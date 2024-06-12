import 'package:barista/models/category.dart';
import 'package:barista/models/product.dart';
import 'package:barista/presentation/product/product.dart';
import 'package:barista/presentation/products/bloc/products_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_shimmer.dart';
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
    ProductsBloc.get(context)
        .add(ProductsGetProductsEvent(categoryId: widget.category.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
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
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      return productItem(state.products[index]);
                    },
                  );
                }
              },
            );
          } else if (state is ProductsErrorState) {
            return errorWidget(
              state.message,
              () {
                ProductsBloc.get(context).add(
                    ProductsGetProductsEvent(categoryId: widget.category.id));
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
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 10,
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
