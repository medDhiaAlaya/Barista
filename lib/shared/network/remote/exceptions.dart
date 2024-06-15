class MyException implements Exception {
  final String message;
  MyException({required this.message});
}

//login Excptions
class UnauthorizedAuthException extends MyException {
  UnauthorizedAuthException({required super.message});
}

class InvalidDataAuthException extends MyException {
  InvalidDataAuthException({required super.message});
}

// Generic Exceptions


class GenericAuthException extends MyException {
  GenericAuthException({required super.message});
}

class DataAlreadyInUserException extends MyException {
  DataAlreadyInUserException({required super.message});
}

class AnotherException extends MyException {
  AnotherException({required super.message});
}
//data exception
class GenericDataFetchException extends MyException {
  GenericDataFetchException({required super.message});
}
//no internet exception
class NoInternetConnectionException extends MyException {
  NoInternetConnectionException({required super.message});
}
