import 'package:barista/models/coffee.dart';
import 'package:barista/shared/network/remote/data/data_services.dart';
import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  static WelcomeBloc get(context) => BlocProvider.of<WelcomeBloc>(context);

  WelcomeBloc(DataService dataService) : super(WelcomeInitialState()) {
    on<WelcomeGetCoffeeEvent>((event, emit) async {
       try {
        emit(WelcomeLoadingState());
        final coffee = await dataService.getCoffee(coffeeId: event.coffeeId);
        emit(WelcomeSucessState(coffee: coffee));
      } on MyException catch (e) {
        emit(WelcomeErrorState(message: e.message));
      } catch (e) {
        emit(WelcomeErrorState(message: "An error occured!"));
      }
    });
  }
}
