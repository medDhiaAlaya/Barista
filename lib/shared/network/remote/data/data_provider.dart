import 'package:barista/models/category.dart';
import 'package:barista/models/coffee.dart';
import 'package:barista/models/product.dart';
import 'package:barista/shared/helpers/connection_checker.dart';
import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data.dart';

class DataProvider implements Data {
  static final DataProvider _shared = DataProvider._sharedInstance();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DataProvider._sharedInstance();
  factory DataProvider() => _shared;

  @override
  Future<Coffee> getCoffee({required String coffeeId}) async {
    try {
      await checkConnection();
      final data = await _firestore.collection('coffee').doc(coffeeId).get();
      if (!data.exists) {
        throw GenericDataFetchException(message: 'Coffee not found!');
      } else {
        final coffee = Coffee(
          id: data.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          admin: data['admin'] ?? '',
        );
        return coffee;
      }
    } on GenericDataFetchException {
      rethrow;
    } on FirebaseException catch (e) {
      throw GenericDataFetchException(message: e.message ?? 'An error occured');
    } on NoInternetConnectionException {
      rethrow;
    } catch (_) {
      throw AnotherException(message: 'An error occured');
    }
  }

  @override
  Future<List<Product>> getCategoryProducts(
      {required String categoryId}) async {
    try {
      await checkConnection();
      final response = await _firestore
          .collection('product')
          .where('category_id', isEqualTo: categoryId)
          .get();
      final data = response.docs;
      final List<Product> products = [];
      for (var element in data) {
        products.add(
          Product(
            id: element.id,
            name: element['name'] ?? '',
            price: double.tryParse(element['price']?.toString() ?? '0') ?? 0,
            description: element['description'] ?? '',
            banner: element['banner'] ?? '',
            images: List<String>.from(element['images']?? []) ,
            categoryId: categoryId,
          ),
        );
      }
      return products;
    } on FirebaseException catch (e) {
      throw GenericDataFetchException(message: e.message ?? 'An error occured');
    } on NoInternetConnectionException {
      rethrow;
    } catch (_) {
      print(_);
      throw AnotherException(message: 'An error occured');
    }
  }

  @override
  Future<List<Category>> getCoffeeCategories({required String coffeeId}) async {
    try {
      await checkConnection();
      final response = await _firestore
          .collection('category')
          .where('coffee_id', isEqualTo: coffeeId)
          .get();
      final data = response.docs;
      final List<Category> categories = [];
      for (var element in data) {
        categories.add(
          Category(
            id: element.id,
            name: element['name'] ?? '',
            image: element['image'] ?? '',
            coffeeId: element['coffee_id'] ?? '',
          ),
        );
      }
      return categories;
    } on FirebaseException catch (e) {
      throw GenericDataFetchException(message: e.message ?? 'An error occured');
    } on NoInternetConnectionException {
      rethrow;
    } catch (_) {
      throw AnotherException(message: 'An error occured');
    }
  }
}
