part of 'home_bloc.dart';

@immutable
class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomePermissionErrorState extends HomeState {
  final String message;
  HomePermissionErrorState({required this.message});
}
final class HomePermissionSuccessState extends HomeState {}

final class HomeQRScanErrorState extends HomeState {
  final String message;
  HomeQRScanErrorState({required this.message});
}
final class HomeQRScanSuccessState extends HomeState {
  final String ssid;
  final String password;
  final String coffeeId;
  HomeQRScanSuccessState({required this.ssid,required this.coffeeId,required this.password});
}

final class HomeConnectToWifiErrorState extends HomeState {
  final String message;
  HomeConnectToWifiErrorState({required this.message});
}
final class HomeConnectToWifiSuccessState extends HomeState {
  final String coffeeId;
    HomeConnectToWifiSuccessState({required this.coffeeId});
}



final class HomeGenericErrorState extends HomeState {}
final class HomeSuccessState extends HomeState {}
final class HomeLoadingState extends HomeState {
  final String message;
  HomeLoadingState({required this.message});
}



