// Flutter imports:
import 'package:flutter/material.dart';

class BottomLine extends StatelessWidget {
  const BottomLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Color(0xff053EFF), Color(0xff053EFF)]),
      ),
    );
  }
}
