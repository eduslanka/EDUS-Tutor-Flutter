import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../model/quets_model.dart';

class QuoteOfTheDayWidget extends StatefulWidget {
  final Quote quote;
  const QuoteOfTheDayWidget({super.key, required this.quote});

  @override
  _QuoteOfTheDayWidgetState createState() => _QuoteOfTheDayWidgetState();
}

class _QuoteOfTheDayWidgetState extends State<QuoteOfTheDayWidget> {
  bool isToggled = false;

  void _toggleImage() {
    setState(() {
      isToggled = !isToggled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: AutoSizeText(
                  '“${isToggled ? widget.quote.meaning : widget.quote.quote}”',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 24,
                  maxLines: isToggled ? 3 : 2,
                  minFontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  bottom: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isToggled ? '- Thirukkural -' : '- திருக்குறள் -',
                      style: const TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: _toggleImage,
                      child: Image.asset(
                        'assets/images/translation_2282220.png', // path to default image
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
