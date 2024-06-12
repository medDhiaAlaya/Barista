part of 'welcome_bloc.dart';

@immutable
sealed class WelcomeState {}

final class WelcomeInitialState extends WelcomeState {}
final class WelcomeLoadingState extends WelcomeState {}
final class WelcomeSucessState extends WelcomeState {
  final Coffee coffee;
  WelcomeSucessState({required this.coffee});
}
final class WelcomeErrorState extends WelcomeState {
  final String message;
  WelcomeErrorState({required this.message});
}
