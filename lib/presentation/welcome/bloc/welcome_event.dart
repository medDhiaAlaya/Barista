part of 'welcome_bloc.dart';

@immutable
class WelcomeEvent {}
class WelcomeGetCoffeeEvent extends WelcomeEvent {
  final String coffeeId;
  WelcomeGetCoffeeEvent({required this.coffeeId});
}
