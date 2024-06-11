import 'package:barista/shared/helpers/loger.dart';
import 'package:bloc/bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    'onCreate -- ${bloc.runtimeType}'.log();
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    'onChange -- ${bloc.runtimeType}, $change'.log();
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    'onError -- ${bloc.runtimeType}, $error'.log();
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    'onClose -- ${bloc.runtimeType}'.log();
  }
}