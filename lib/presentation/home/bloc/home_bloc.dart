import 'dart:convert';
import 'package:barista/models/qr_data.dart';
import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc get(context) => BlocProvider.of<HomeBloc>(context);
  HomeBloc() : super(HomeInitialState()) {
    on<HomeScanQREvent>((event, emit) {
      try {
        emit(HomeLoadingState(message: 'Please wait...'));
        Map<String, dynamic> jsonData = jsonDecode(event.data);
        final String? ssid = jsonData["ssid"];
        final String? password = jsonData["password"];
        final String? coffeeId = jsonData["coffee_id"];
        if (ssid == null || password == null || coffeeId == null) {
          emit(HomeQRScanErrorState(message: "Please verify your qr code."));
        } else {
          emit(HomeQRScanSuccessState(qrData: QrData(coffeeId: coffeeId, ssid: ssid, password: password)));
        }
      } on MyException catch (e) {
        emit(HomeQRScanErrorState(message: e.message));
      } catch (e) {
        emit(HomeQRScanErrorState(message: "Please verify your qr code."));
      }
    });
    on<HomeGetPermissionEvent>((event, emit) async {
      try {
        final result = await Permission.camera.request();
        if (result.isGranted) {
          emit(HomePermissionSuccessState());
        } else {
          emit(HomePermissionErrorState(
              message: "Please give access to camera."));
        }
      } on MyException catch (e) {
        emit(HomeQRScanErrorState(message: e.message));
      } catch (e) {
        emit(
          HomePermissionErrorState(
            message: "Please give access to camera.",
          ),
        );
      }
    });
    on<HomeConnectToWifiEvent>((event, emit) async {
      try {
        emit(HomeLoadingState(message: 'Connecting to ${event.qrData.ssid}...'));
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.wifi ||
            connectivityResult == ConnectivityResult.mobile) {
          emit(HomeConnectToWifiSuccessState(qrData: event.qrData));
        } else {
          final bool isEnabled = await WiFiForIoTPlugin.isEnabled();
          if (isEnabled) {
            final bool isConnected = await WiFiForIoTPlugin.connect(
              event.qrData.ssid,
              password: event.qrData.password,
              security: NetworkSecurity.WPA,
              withInternet: true,
              joinOnce: false,
            );
            if (isConnected) {
              emit(HomeConnectToWifiSuccessState(qrData: event.qrData));
            } else {
              emit(HomeConnectToWifiErrorState(
                message: "Unable to connect to wifi!",
              ));
            }
          } else {
            emit(
              HomeConnectToWifiErrorState(
                message: "Please enable your wifi",
              ),
            );
          }
        }
      } on MyException catch (e) {
        emit(HomeQRScanErrorState(message: e.message));
      } catch (e) {
        emit(
          HomeConnectToWifiErrorState(
            message: "Please give access to camera.",
          ),
        );
      }
    });
  }
}
