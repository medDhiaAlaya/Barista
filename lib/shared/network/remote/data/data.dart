import 'package:barista/models/category.dart';
import 'package:barista/models/coffee.dart';
import 'package:barista/models/product.dart';

abstract class Data {
  Future<Coffee> getCoffee({required String coffeeId});
  Future<List<Category>> getCoffeeCategories({required String coffeeId});
  Future<List<Product>> getCategoryProducts({required String categoryId});
}
