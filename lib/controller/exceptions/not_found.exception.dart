import 'package:logger/logger.dart';

class NotFoundException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  NotFoundException({
    this.message = 'Data not found',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
