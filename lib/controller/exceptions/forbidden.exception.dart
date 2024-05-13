import 'package:logger/logger.dart';

class ForbiddenException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ForbiddenException({
    this.message = 'Data not found',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
