// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';

// Package imports:
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../config/app_size.dart';

class Utils extends GetxController {
  static Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  static Future<bool> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Widget contactUs(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 12),
            ),
            h8,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      // var url = Uri.parse('https://wa.me/+94774487774?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
                      UrlLauncher.launch(
                          'https://wa.me/+94774487774?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
                    },
                    child: SvgPicture.asset(
                      'assets/config/whats-app-whatsapp-whatsapp-icon-svgrepo-com.svg',
                      height: 25,
                      width: 40,
                    )),
                w16,
                GestureDetector(
                    onTap: () {
                      UrlLauncher.launch("tel:+94774487774");
                    },
                    child: SvgPicture.asset(
                      'assets/config/phone-call-svgrepo-com.svg',
                      height: 25,
                      width: 40,
                    )),
                w8,
              ],
            ),
          ],
        ),
      ],
    );
  }

  static const isAllowKey = 'isAllow';
  static void showCommentDialog(BuildContext context,
      {String title = 'Access Disabled',
      String message = '''
Your access has been suspended due to unpaid fees. If payment has been made, please contact admin.

Reminder: Fees are due by the 5th of each month. Kindly settle your dues to restore access.

Thank you!'''}) {
    showDialog(
      context: context,
      barrierDismissible: true, // Prevent closing by tapping outside

      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: screenHeight(300, context),
            child: Column(
              children: [
                Text(message),
                contactUs(context),
                h8,
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    width: screenWidth(200, context),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Utils.baseBlue),
                    child: Center(
                        child: Text(
                      'OK',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> saveIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  static Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<String?> getStringValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString(key));
    return prefs.getString(key);
  }

  static Future<int?> getIntValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();
    return prefs.getInt(key);
  }

  static Future<bool> clearAllValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }

  static Future<String> getTranslatedLanguage(
      String languageCode, String key) async {
    Map<dynamic, dynamic> localisedValues;
    String jsonContent = await rootBundle
        .loadString("assets/locale/localization_$languageCode.json");
    localisedValues = json.decode(jsonContent);
    return localisedValues[key] ?? key;
  }

  static setHeader(String token) {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    return header;
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: const Color(0xff053EFF),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Color baseBlue = const Color(0xff053EFF);
  static BoxDecoration gradientBtnDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      gradient: const LinearGradient(
        colors: [
          Color.fromARGB(255, 2, 87, 255),
          Color(0xff053EFF),
        ],
      ));

  static Text checkTextValue(text, value) {
    return Text(
      "$text:: $value",
      style: const TextStyle(fontSize: 18),
    );
  }

  static Widget noDataWidget({String text = 'No data available'}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Get.textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
