import 'package:logger/logger.dart';

class TimeOutException implements Exception {
  final String message;
  TimeOutException({
    this.message = 'Timeout when trying to connect to the server',
  }) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
