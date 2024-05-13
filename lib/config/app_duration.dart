import 'package:get/get.dart';

class AppDuration {
  static const int carouselDelayTime = 6; //second
  static const double messageTime = 2;
  static Duration messageAnimationTime = 200.milliseconds;
  static const int appMenuAnimationDuration = 200;
  static Duration snackBarAnimation = 100.milliseconds; //milliseconds

  static Duration messageTotalDuration({
    double messageTime = messageTime,
  }) {
    return (messageAnimationTime * 2) + messageTime.seconds + 150.milliseconds;
  }
}
