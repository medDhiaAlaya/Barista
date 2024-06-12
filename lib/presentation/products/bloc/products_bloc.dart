import 'package:barista/models/product.dart';
import 'package:barista/shared/network/remote/data/data_services.dart';
import 'package:barista/shared/network/remote/exceptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  static ProductsBloc get(context) => BlocProvider.of<ProductsBloc>(context);
  ProductsBloc(DataService dataService) : super(ProductsInitialState()) {
    on<ProductsGetProductsEvent>((event, emit) async {
      try {
        emit(ProductsLoadingState());
        final List<Product> products =
            await dataService.getCategoryProducts(categoryId: event.categoryId);
        emit(ProductsSuccessState(products: products));
      } on MyException catch (e) {
        emit(ProductsErrorState(message: e.message));
      } catch (e) {
        emit(ProductsErrorState(message: "An error occured!"));
      }
    });
  }
}
