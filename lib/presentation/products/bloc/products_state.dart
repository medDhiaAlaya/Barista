part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitialState extends ProductsState {}
final class ProductsLoadingState extends ProductsState {}
final class ProductsSuccessState extends ProductsState {
  final List<Product> products;
  ProductsSuccessState({required this.products});
}
final class ProductsErrorState extends ProductsState {
  final String message;
  ProductsErrorState({required this.message});
}
