import 'package:logger/logger.dart';

class LocationNotFoundException implements Exception {
  final String message;

  LocationNotFoundException({this.message = 'location not found'}) {
    Logger().w(message);
  }

  @override
  String toString() => message;
}
