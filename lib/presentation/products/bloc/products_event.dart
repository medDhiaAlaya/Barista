part of 'products_bloc.dart';

@immutable
class ProductsEvent {}
class ProductsGetProductsEvent extends ProductsEvent {
  final String categoryId;
  ProductsGetProductsEvent({required this.categoryId});
}
