// Flutter imports:
import 'package:flutter/material.dart';

class CookieButton extends StatelessWidget {
  final String? text;
  final Function? onPressed;

  const CookieButton({Key? key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 64,
      width: MediaQuery.of(context).size.width * .4,
      child: ElevatedButton(
        child: FittedBox(
            child: Text(text ?? '',
                style: const TextStyle(color: Colors.white, fontSize: 18))),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
        ),
        // onPressed: onPressed,
        onPressed: onPressed as void Function(),
      ));
}
