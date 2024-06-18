import 'package:barista/models/category.dart';
import 'package:barista/models/coffee.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/presentation/cart/shopping_cart.dart';
import 'package:barista/presentation/categories/bloc/categories_bloc.dart';
import 'package:barista/presentation/products/products.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_shimmer.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatefulWidget {
  final Coffee coffee;
  const CategoriesScreen({super.key, required this.coffee});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    CategoriesBloc.get(context).add(
      CategoriesGetCategoriesEvent(
        coffeeId: widget.coffee.id,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text(widget.coffee.name),
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
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesSuccessState) {
            return RefreshIndicator(
              onRefresh: () async {
                CategoriesBloc.get(context).add(
                  CategoriesGetCategoriesEvent(
                    coffeeId: widget.coffee.id,
                  ),
                );
              },
              child: Builder(
                builder: (context) {
                  if (state.categories.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 200,
                        ),
                        Center(
                          child: DefaultText(
                            text: 'No categories found!',
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
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        return categoryItem(state.categories[index]);
                      },
                    );
                  }
                },
              ),
            );
          } else if (state is CategoriesErrorState) {
            return errorWidget(
              state.message,
              () {
                CategoriesBloc.get(context).add(
                  CategoriesGetCategoriesEvent(
                    coffeeId: widget.coffee.id,
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

  Widget categoryItem(Category category) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductsScreen(
              category: category,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                  category.image,
                ),
              ),
              DefaultText(
                text: category.name,
                textSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
