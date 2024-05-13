import 'package:logger/logger.dart';

class UserNameAlreadyExistsException implements Exception {
  final String message;

  UserNameAlreadyExistsException({this.message = 'Username already exist'}) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
