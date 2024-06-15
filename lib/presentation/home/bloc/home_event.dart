part of 'home_bloc.dart';

@immutable
class HomeEvent {}
class HomeGetPermissionEvent extends HomeEvent {}

class HomeScanQREvent extends HomeEvent {
  final String data;
  HomeScanQREvent({required this.data});
}

class HomeConnectToWifiEvent extends HomeEvent {
  final QrData qrData;
  HomeConnectToWifiEvent({required this.qrData});
}
