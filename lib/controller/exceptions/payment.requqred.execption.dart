import 'package:logger/logger.dart';

class PaymentRequiredException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  PaymentRequiredException({
    this.message = 'Data not found',
    this.stackTrace,
  }) {
    Logger().e(stackTrace);
  }

  @override
  String toString() => message;
}
