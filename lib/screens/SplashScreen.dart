import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Project imports:
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/controller/system_controller.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/Utils.dart';
// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

import 'onbording_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Route route;

    Future.delayed(const Duration(seconds: 3), () {
      getBooleanValue('isLogged').then((value) {
        if (value) {
          final SystemController _systemController = Get.put(SystemController());
          _systemController.getSystemSettings();
          Utils.getStringValue('rule').then((rule) {
            AppFunction.getFunctions(context, rule ?? '');
          });
        } else {
          if (mounted) {
            route = MaterialPageRoute(builder: (context) => const OnbordingScreen());
            Navigator.pushReplacement(context, route);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppConfig.splashScreenBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Welcome to'.tr,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    height: 100.0, // Fixed height
                    width: 100.0,  // Fixed width
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(AppConfig.appLogo),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      AppConfig.appName,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, left: 40, right: 40),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> getBooleanValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
