import 'dart:convert';

import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';

import '../model/quets_model.dart';
import 'package:http/http.dart' as http;

import '../model/today_class_model.dart';
Future<Quote> fetchQuoteOfTheDay() async {
  final response = await http.get(Uri.parse('http://thurukural.edustutor.com/quote-of-the-day'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(response.body);
    return Quote.fromMap(data);
  } else {
    throw Exception('Failed to load quote of the day');
  }
}

Future<TodayClassResponse> fetchTodayClasses(String token) async {
  try {
    final response = await http.get(
      Uri.parse(EdusApi.todayClass),
      headers: Utils.setHeader(token),
    );
    print(EdusApi.todayClass);

    if (response.statusCode == 200) {
      return TodayClassResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load today classes: ${response.body} ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load today classes: $e');
  }
}
