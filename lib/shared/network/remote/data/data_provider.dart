import 'package:dio/dio.dart';

import 'package:path/path.dart' as p;

import '../../urls.dart';
import 'data.dart';

class DataProvider implements Data {
  late Dio dio;

  static final DataProvider _shared = DataProvider._sharedInstance();

  DataProvider._sharedInstance();
  factory DataProvider() => _shared;

  @override
  void initialize() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        receiveTimeout: 15 * 1000,
        sendTimeout: 15 * 1000,
        connectTimeout: 15 * 1000,
      ),
    );
  }

}
