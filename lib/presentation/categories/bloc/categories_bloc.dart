import 'package:barista/shared/network/remote/data/data_services.dart';
import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:barista/models/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  static CategoriesBloc get(context) => BlocProvider.of<CategoriesBloc>(context);
  CategoriesBloc(DataService dataService) : super(CategoriesInitialState()) {
    on<CategoriesGetCategoriesEvent>((event, emit) async {
       try {
        emit(CategoriesLoadingState());
        final List<Category> categories = await dataService.getCoffeeCategories(coffeeId: event.coffeeId);
        emit(CategoriesSuccessState(categories: categories));
      } on MyException catch (e) {
        emit(CategoriesErrorState(message: e.message));
      } catch (e) {
        emit(CategoriesErrorState(message: "An error occured!"));
      }
    });
  }
}
