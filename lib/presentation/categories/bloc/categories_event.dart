part of 'categories_bloc.dart';

@immutable
class CategoriesEvent {}
class CategoriesGetCategoriesEvent extends CategoriesEvent {
  final String coffeeId;
  CategoriesGetCategoriesEvent({required this.coffeeId});
}
