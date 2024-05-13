import 'package:logger/logger.dart';

class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException({this.message = 'User already registered!'}) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
