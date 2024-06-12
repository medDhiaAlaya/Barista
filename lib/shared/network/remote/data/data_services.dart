import 'package:barista/models/category.dart';

import 'package:barista/models/coffee.dart';

import 'package:barista/models/product.dart';

import 'data.dart';
import 'data_provider.dart';

class DataService implements Data {
  final Data dataProvider;

  DataService(this.dataProvider);

  factory DataService.instance() => DataService(DataProvider());

  @override
  Future<List<Product>> getCategoryProducts({required String categoryId}) =>
      dataProvider.getCategoryProducts(
        categoryId: categoryId,
      );

  @override
  Future<Coffee> getCoffee({required String coffeeId}) =>
      dataProvider.getCoffee(coffeeId: coffeeId);

  @override
  Future<List<Category>> getCoffeeCategories({required String coffeeId}) =>
      dataProvider.getCoffeeCategories(
        coffeeId: coffeeId,
      );
}
