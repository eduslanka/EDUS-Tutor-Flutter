import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/language/language_selection.dart';
import 'package:edus_tutor/language/translation.dart';
import 'package:edus_tutor/utils/widget/cc.dart';
import 'package:edus_tutor/screens/SplashScreen.dart';
import 'package:lottie/lottie.dart';

import '../../controller/InternetController.dart';
import '../../main.dart';
import '../Utils.dart';
import '../error.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final LanguageController languageController = Get.put(LanguageController());
  final CustomController controller = Get.put(CustomController());
  bool? isRTL;

  // Define the base theme
  ThemeData get _baseTheme {
    return ThemeData(
      fontFamily: 'popins', // Use custom Poppins font family
      primaryColor: const Color(0xff053EFF), // Button color
      scaffoldBackgroundColor: Colors.white, // Background color
      // textTheme: const TextTheme(
      //   bodyText1: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      //   bodyText2: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      //   headline6: TextStyle(fontWeight: FontWeight.w500), // Semi-bold
      //   subtitle1: TextStyle(fontWeight: FontWeight.w300), // Light

      // ),
      // primaryColor:Color(0xff053EFF),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff053EFF), // Blue
        onPrimary: Colors.white, // Text/icons on blue
        secondary: Color(0xff053EFF), // Secondary color is also blue
        onSecondary: Colors.white, // Text/icons on secondary
        background: Colors.white, // Background
        onBackground: Colors.black, // Text/icons on white
        surface: Colors.white, // Surface (cards, etc.)
        onSurface: Colors.black, // Text/icons on surfaces
        error: Colors.red, // Error color
        onError: Colors.white, // Text/icons on error
      ),
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff053EFF),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          fontFamily: 'popins',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff053EFF), // Button color
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: 'popins',
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Utils.getIntValue('locale').then((value) {
      setState(() {
        isRTL = value == 0 ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (_, child) {
            return Obx(() {
              if (controller.isLoading.value) {
                return MaterialApp(
                  theme: _baseTheme,
                  builder: EasyLoading.init(),
                  debugShowCheckedModeBanner: false,
                  home: const Scaffold(
                    body: Center(child: CupertinoActivityIndicator()),
                  ),
                );
              } else {
                if (controller.connected.value) {
                  return isRTL != null
                      ? GetMaterialApp(
                          title: AppConfig.appName,
                          theme: _baseTheme, // Apply the theme
                          debugShowCheckedModeBanner: false,
                          locale: langValue
                              ? Get.deviceLocale
                              : Locale(LanguageSelection.instance.val),
                          translations: LanguageController(),
                          fallbackLocale: const Locale('en_US'),
                          builder: EasyLoading.init(),
                          home: FutureBuilder(
                            future: _initialization,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Scaffold(
                                  body: Center(
                                    child: Text(
                                      snapshot.error.toString(),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return const Scaffold(
                                  body: Splash(),
                                );
                              }
                              return const CircularProgressIndicator();
                            },
                          ),
                        )
                      : const Material(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        );
                } else {
                  return GetMaterialApp(
                    theme: _baseTheme, // Apply the theme
                    builder: EasyLoading.init(),
                    locale: langValue
                        ? Get.deviceLocale
                        : Locale(LanguageSelection.instance.val),
                    translations: LanguageController(),
                    fallbackLocale: const Locale('en_US'),
                    debugShowCheckedModeBanner: false,
                    home: internetController.internet.isTrue
                        ? controller.connectedStatus.isTrue
                            ? ErrorPage(
                                message: controller.serverMessage.toString(),
                              )
                            : const ErrorPage()
                        : Center(
                            child: Container(
                              height: Get.height,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                      'assets/images/no_internet.json'),
                                  const Text(
                                      'Connect with Internet and Restart App.')
                                ],
                              ),
                            ),
                          ),
                  );
                }
              }
            });
          }),
    );
  }
}
