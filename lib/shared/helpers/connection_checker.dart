import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


Future<void> checkConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.wifi &&
      connectivityResult != ConnectivityResult.mobile) {
    throw NoInternetConnectionException(message: 'Please check your connection');
  }
}