import 'package:logger/logger.dart';

class ConflictException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  ConflictException({
    this.message = 'Error loading data, check your internet!',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
