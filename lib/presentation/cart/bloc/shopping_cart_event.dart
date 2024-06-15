part of 'shopping_cart_bloc.dart';

@immutable
class ShoppingCartEvent {}
class ShoppingCartAddItemEvent extends ShoppingCartEvent {
  final ShoppingCartItem shoppingCartItem;
  ShoppingCartAddItemEvent({required this.shoppingCartItem});
}
class ShoppingCartRemoveItemEvent extends ShoppingCartEvent {
  final ShoppingCartItem shoppingCartItem;
  ShoppingCartRemoveItemEvent({required this.shoppingCartItem});
}
class ShoppingCartUpdateItemEvent extends ShoppingCartEvent {
  final ShoppingCartItem shoppingCartItem;
  final int quantity;
  ShoppingCartUpdateItemEvent({required this.shoppingCartItem,required this.quantity});
}
class ShoppingCartClearEvent extends ShoppingCartEvent {}
