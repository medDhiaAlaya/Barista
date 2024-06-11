import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
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
          emit(HomeQRScanSuccessState(
              ssid: ssid, coffeeId: coffeeId, password: password));
        }
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
      } 
      catch (e) {
        emit(
          HomePermissionErrorState(
            message: "Please give access to camera.",
          ),
        );
      }
    });
    on<HomeConnectToWifiEvent>((event, emit) async {
      try {
        emit(HomeLoadingState(message: 'Connecting to WiFi...'));
        final bool isEnabled = await WiFiForIoTPlugin.isEnabled();
        if (isEnabled) {
          final bool isConnected = await WiFiForIoTPlugin.connect(event.ssid,
              password: event.password);
          if (isConnected) {
            HomeConnectToWifiSuccessState(coffeeId: event.coffeeId);
          } else {
            HomeConnectToWifiErrorState(
              message: "Unable to connect to wifi!",
            );
          }
        } else {
          emit(
            HomeConnectToWifiErrorState(
              message: "Please enable your wifi",
            ),
          );
        }
        emit(HomeConnectToWifiSuccessState(coffeeId: event.coffeeId));
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
