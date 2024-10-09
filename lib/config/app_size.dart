import 'package:flutter/cupertino.dart';

double screenWidth(double size, BuildContext context) {
  return (MediaQuery.of(context).size.width / 412) * size;
}

double screenHeight(double size, BuildContext context) {
  return (MediaQuery.of(context).size.height / 804) * size;
}

SizedBox h8 = const SizedBox(
  height: 8,
);
SizedBox h16 = const SizedBox(
  height: 16,
);
SizedBox w8 = const SizedBox(
  width: 8,
);
SizedBox w16 = const SizedBox(
  width: 16,
);
