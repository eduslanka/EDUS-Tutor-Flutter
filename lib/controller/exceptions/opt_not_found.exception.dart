import 'package:logger/logger.dart';

class OtpNotFoundException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  OtpNotFoundException({
    this.message = 'Data not found',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
