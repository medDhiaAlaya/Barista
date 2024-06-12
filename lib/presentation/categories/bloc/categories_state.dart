part of 'categories_bloc.dart';

@immutable
class CategoriesState {}

final class CategoriesInitialState extends CategoriesState {}
final class CategoriesLoadingState extends CategoriesState {}
final class CategoriesSuccessState extends CategoriesState {
  final List<Category> categories;
  CategoriesSuccessState({required this.categories});
}
final class CategoriesErrorState extends CategoriesState {
  final String message;
  CategoriesErrorState({required this.message});
}


