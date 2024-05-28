import 'dart:convert';

import '../model/quets_model.dart';
import 'package:http/http.dart' as http;
Future<Quote> fetchQuoteOfTheDay() async {
  final response = await http.get(Uri.parse('http://thurukural.edustutor.com/quote-of-the-day'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return Quote.fromMap(data);
  } else {
    throw Exception('Failed to load quote of the day');
  }
}