import 'package:logger/logger.dart';

class UnProcessableException implements Exception {
  final String message;

  UnProcessableException({this.message = 'Un-processable exception'}) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
