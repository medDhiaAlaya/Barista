import 'package:barista/models/category.dart';
import 'package:barista/models/coffee.dart';
import 'package:barista/presentation/categories/bloc/categories_bloc.dart';
import 'package:barista/presentation/products/products.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/components/error_widget.dart';
import 'package:barista/shared/components/loading_shimmer.dart';
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
    CategoriesBloc.get(context)
        .add(CategoriesGetCategoriesEvent(coffeeId: widget.coffee.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coffee.name),
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesSuccessState) {
            return Builder(
              builder: (context) {
                if (state.categories.isEmpty) {
                  return const Center(
                    child: DefaultText(
                      text: 'No categories found!',
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
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      return categoryItem(state.categories[index]);
                    },
                  );
                }
              },
            );
          } else if (state is CategoriesErrorState) {
            return errorWidget(
              state.message,
              () {
                CategoriesBloc.get(context).add(
                    CategoriesGetCategoriesEvent(coffeeId: widget.coffee.id));
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
              text: category.name,
              textSize: 18,
            ),
          ],
        ),
      ),
    );
  }
}
