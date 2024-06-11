part of 'home_bloc.dart';

@immutable
class HomeEvent {}
class HomeGetPermissionEvent extends HomeEvent {}

class HomeScanQREvent extends HomeEvent {
  final String data;
  HomeScanQREvent({required this.data});
}

class HomeConnectToWifiEvent extends HomeEvent {
  final String coffeeId;
  final String ssid;
  final String password;
  HomeConnectToWifiEvent({required this.ssid,required this.password,required this.coffeeId});
}
