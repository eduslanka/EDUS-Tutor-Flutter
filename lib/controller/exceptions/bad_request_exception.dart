
import 'package:logger/logger.dart';

class BadRequestException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  BadRequestException({
    this.message = 'Bad request!',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
