import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_service/app_service.dart';
import '../model/quets_model.dart';


class QuoteOfTheDayWidget extends StatefulWidget {
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
        child: FutureBuilder<Quote>(
          future: fetchQuoteOfTheDay(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(color: Colors.black12,),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final quote = snapshot.data!;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: AutoSizeText(
                      '“${isToggled? quote.meaning: quote.quote}”',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxFontSize: 24,
                      maxLines: 2,
                      minFontSize: 14,
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
                         Text(isToggled?'- Thirukkural -' :'- திருக்குறள் -'),
                        GestureDetector(
                          onTap: _toggleImage,
                          child: SvgPicture.asset(
                        
                               'assets/images/two-arrows.svg', // path to default image
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No quote available.'));
            }
          },
        ),
      ),
    );
  }
}
