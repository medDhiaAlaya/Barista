import 'package:barista/models/shopping_cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  static ShoppingCartBloc get(context) =>
      BlocProvider.of<ShoppingCartBloc>(context);
  ShoppingCart shoppingCart = ShoppingCart(
    items: [],
    totalPrice: 0,
  );
  ShoppingCartBloc() : super(ShoppingCartInitialState()) {
    on<ShoppingCartAddItemEvent>((event, emit) {
      try {
        shoppingCart.items.add(event.shoppingCartItem);
        shoppingCart.totalPrice += event.shoppingCartItem.totalPrice;
        emit(ShoppingCartSuccessState());
      } catch (e) {
        emit(ShoppingCartErrorState(message: "An error occured!"));
      }
    });
    on<ShoppingCartRemoveItemEvent>((event, emit) {
      try {
        shoppingCart.items.removeWhere(
            (item) => item.product.id == event.shoppingCartItem.product.id);
        shoppingCart.totalPrice -= event.shoppingCartItem.totalPrice;
        emit(ShoppingCartSuccessState());
      } catch (e) {
        emit(ShoppingCartErrorState(message: "An error occured!"));
      }
    });
    on<ShoppingCartUpdateItemEvent>((event, emit) {
      try {
        //remove item from list
        shoppingCart.items.removeWhere(
          (item) => item.product.id == event.shoppingCartItem.product.id,
        );
        //remove current item price
        shoppingCart.totalPrice -= event.shoppingCartItem.totalPrice;
        //update quantity
        event.shoppingCartItem.quantity = event.quantity;
        //update new item price
        event.shoppingCartItem.totalPrice =
            event.shoppingCartItem.product.price * event.quantity;
        //adding new item price
        shoppingCart.totalPrice += event.shoppingCartItem.totalPrice;
        //adding new item
        shoppingCart.items.add(event.shoppingCartItem);
        emit(ShoppingCartSuccessState());
      } catch (e) {
        emit(ShoppingCartErrorState(message: "An error occured!"));
      }
    });
    on<ShoppingCartClearEvent>((event, emit) {
      shoppingCart.items.clear();
      shoppingCart.totalPrice = 0;
      emit(ShoppingCartSuccessState());
    });
  }
}
