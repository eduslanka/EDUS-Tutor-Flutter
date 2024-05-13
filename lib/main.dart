import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/fees/paymentGateway/khalti/sdk/khalti.dart';
import 'utils/widget/page.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ignore: prefer_typing_uninitialized_variables
var language;
bool langValue = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor:
        const Color(0xff280073), //or set color with: Color(0xFF0000FF)
  ));
  HttpOverrides.global = MyHttpOverrides();
  final sharedPref = await SharedPreferences.getInstance();
  language = sharedPref.getString('language');
  debugPrint(language);
  await Khalti.init(
    publicKey: khaltiPublicKey,
    enabledDebugging: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return const MainPage();
  }
}
