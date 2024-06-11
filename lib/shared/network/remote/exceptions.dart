class MyException implements Exception {
  final String message;
  MyException({required this.message});
}

//login Excptions
class UnauthorizedAuthException extends MyException {
  UnauthorizedAuthException({required String message}) : super(message: message);
}

class InvalidDataAuthException extends MyException {
  InvalidDataAuthException({required String message}) : super(message: message);
}

// Generic Exceptions


class GenericAuthException extends MyException {
  GenericAuthException({required String message}) : super(message: message);
}

class DataAlreadyInUserException extends MyException {
  DataAlreadyInUserException({required String message}) : super(message: message);
}

class AnotherException extends MyException {
  AnotherException({required String message}) : super(message: message);
}
//data exception
class GenericDataFetchException extends MyException {
  GenericDataFetchException({required String message}) : super(message: message);
}
//no internet exception
class NoInternetConnectionException extends MyException {
  NoInternetConnectionException({required String message}) : super(message: message);
}
