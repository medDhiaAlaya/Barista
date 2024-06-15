part of 'shopping_cart_bloc.dart';

@immutable
class ShoppingCartState {}

final class ShoppingCartInitialState extends ShoppingCartState {}
final class ShoppingCartSuccessState extends ShoppingCartState {}
final class ShoppingCartErrorState extends ShoppingCartState {
  final String message;
  ShoppingCartErrorState({required this.message});
}
