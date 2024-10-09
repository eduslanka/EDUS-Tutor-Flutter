// Flutter imports:
import 'package:flutter/material.dart';

class CookieButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;

  const CookieButton({super.key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 64,
      width: MediaQuery.of(context).size.width * .4,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
        ),
        // onPressed: onPressed,
        onPressed: onPressed as void Function(),
        child: FittedBox(
            child: Text(text ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 18))),
      ));
}
