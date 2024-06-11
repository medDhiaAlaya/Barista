import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import '../../urls.dart';
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
