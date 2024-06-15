import 'package:barista/models/shopping_cart.dart';
import 'package:barista/presentation/cart/bloc/shopping_cart_bloc.dart';
import 'package:barista/shared/components/default_text.dart';
import 'package:barista/shared/helpers/image_loader.dart';
import 'package:barista/shared/helpers/show_dialog.dart';
import 'package:barista/shared/helpers/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: BlocConsumer<ShoppingCartBloc, ShoppingCartState>(
        listener: (context, state) {
          if (state is ShoppingCartErrorState) {
            showToast(state.message, true);
          }
        },
        builder: (context, state) {
          final shoppingCart = ShoppingCartBloc.get(context).shoppingCart;
          return Builder(builder: (context) {
            if (shoppingCart.items.isEmpty) {
              return const Center(
                child: DefaultText(
                  text: 'Shopping cart is empty!',
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: shoppingCart.items.length,
                      itemBuilder: (context, index) {
                        return cartItemWidget(shoppingCart.items[index]);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Center(
                      child: DefaultText(
                        text:
                            'Total: ${ShoppingCartBloc.get(context).shoppingCart.totalPrice.toStringAsFixed(2)} DT',
                        textSize: 18.0,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }
          });
        },
      ),
    );
  }

  Widget cartItemWidget(ShoppingCartItem shoppingCartItem) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: imageLoader(shoppingCartItem.product.banner),
        ),
        trailing: Text(
          '${shoppingCartItem.totalPrice.toStringAsFixed(2)} DT',
        ),
        title: Text(shoppingCartItem.product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: ${shoppingCartItem.product.price.toStringAsFixed(2)} DT',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: shoppingCartItem.quantity > 0
                          ? () {
                              ShoppingCartBloc.get(context).add(
                                ShoppingCartUpdateItemEvent(
                                    shoppingCartItem: shoppingCartItem,
                                    quantity: shoppingCartItem.quantity - 1),
                              );
                            }
                          : null,
                    ),
                    Text(shoppingCartItem.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        ShoppingCartBloc.get(context).add(
                          ShoppingCartUpdateItemEvent(
                              shoppingCartItem: shoppingCartItem,
                              quantity: shoppingCartItem.quantity + 1),
                        );
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    bool? choice = await showAlert(
                      context: context,
                      title: 'Remove Product',
                      content: 'Are you sure ?',
                      optionsBuilder: () => {
                        'No': false,
                        'Yes': true,
                      },
                    );
                    if (choice == true) {
                      ShoppingCartBloc.get(context).add(
                        ShoppingCartRemoveItemEvent(
                          shoppingCartItem: shoppingCartItem,
                        ),
                      );
                      showToast("Product removed", false);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
