import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../../helpers/connection_checker.dart';
import '../../local/cache_helper.dart';
import '../../urls.dart';
import '../exceptions.dart';
import 'auth.dart';

class AuthProvider extends Auth {
  late Dio dio;

  @override
  void initialize() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      receiveTimeout: 15 * 1000,
      sendTimeout: 15 * 1000,
      connectTimeout: 15 * 1000,
    ));
  }

  @override
  Future<void> logIn({
    required String email,
    required String password,
    String lang = 'en',
  }) async {
    try {
      await checkConnection();
      dio.options.headers = {
        'Content-Type': 'application/json',
        'lang': lang,
      };
      String url = p.join(baseUrl, loginEndPoint);
      Map<String, dynamic> data = {"email": email, "password": password};
      final Response response = await dio.post(
        url,
        data: data,
      );
      String token = response.data['token'];
      await CacheHelper.init();
      await CacheHelper.saveData(key: 'token', value: token);
    } on DioError catch (e) {
      switch (e.response!.statusCode) {
        case 401:
          {
            throw UnauthorizedAuthException(message: 'Unauthorized');
          }
        case 422:
          {
            throw InvalidDataAuthException(message: "Wrong Credential !");
          }
        default:
          {
            throw GenericAuthException(message: 'An error occured');
          }
      }
    } on NoInternetConnectionException {
      rethrow;
    } catch (_) {
      throw AnotherException(message: 'An error occured');
    }
  }

  @override
  Future<void> logOut({String lang = 'en'}) async {
    try {
      await checkConnection();
      await CacheHelper.init();
      String token = CacheHelper.getData(key: 'token');
      dio.options.headers = {
        'Content-Type': 'application/json',
        'lang': lang,
        'Authorization': 'Bearer $token'
      };
      String url = p.join(baseUrl, logoutEndPoint);
      await dio.post(url);
      await CacheHelper.removeData(key: 'token');
    } on DioError catch (e) {
      switch (e.response!.statusCode) {
        default:
          throw GenericAuthException(message: 'An error occured');
      }
    } on NoInternetConnectionException {
      rethrow;
    } catch (e) {
      throw AnotherException(message: 'An error occured');
    }
  }

  // @override
  // Future<void> register({
  //   required User user,
  //   String lang = 'en',
  // }) async {
  //   try {
  //     await checkConnection();
  //     dio.options.headers = {
  //       'Content-Type': 'application/json',
  //       'lang': lang,
  //     };
  //     String url = p.join(baseUrl, registerEndPoint);
  //     Map<String, dynamic> data = User.registerUser(user);
  //     await dio.post(
  //       url,
  //       data: data,
  //     );
  //   } on DioError catch (e) {
  //     switch (e.response!.statusCode) {
  //       default:
  //         throw GenericAuthException(message: 'An error occured');
  //     }
  //   } on NoInternetConnectionException {
  //     rethrow;
  //   } catch (_) {
  //     throw AnotherException(message: 'An error occured');
  //   }
  // }

 

}
