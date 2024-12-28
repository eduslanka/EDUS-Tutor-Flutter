import 'package:edus_tutor/utils/theme.dart';
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
  // ThemeData get _baseTheme {
  //   return ThemeData(
  //     fontFamily: 'popins', // Custom font family
  //     primaryColor: const Color(0xff053EFF), // Primary color for buttons, etc.
  //     scaffoldBackgroundColor: Colors.white, // Default background color
  //     textTheme: const TextTheme(
  //       displayLarge: TextStyle(
  //           fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
  //       displayMedium: TextStyle(
  //           fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
  //       displaySmall:
  //           TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Semi-bold
  //       titleLarge: TextStyle(
  //           fontSize: 18,
  //           color: Colors.black,
  //           fontWeight: FontWeight.w600), // Bold
  //       titleMedium: TextStyle(
  //           fontSize: 16,
  //           color: Colors.black,
  //           fontWeight: FontWeight.w400), // Normal
  //       titleSmall:
  //           TextStyle(fontSize: 14, fontWeight: FontWeight.w300), // Light
  //       bodyLarge: TextStyle(
  //           fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
  //       bodyMedium: TextStyle(
  //           fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
  //       bodySmall: TextStyle(
  //           fontSize: 12, color: Colors.black, fontWeight: FontWeight.w300),
  //       labelLarge: TextStyle(
  //           fontSize: 18,
  //           color: Colors.white,
  //           fontWeight: FontWeight.w500), // Button text
  //       labelMedium: TextStyle(
  //           fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
  //       labelSmall: TextStyle(
  //           fontSize: 14, color: Colors.white, fontWeight: FontWeight.w300),
  //     ),
  //     inputDecorationTheme: const InputDecorationTheme(
  //       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  //       hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
  //       labelStyle: TextStyle(fontSize: 12, color: Colors.black),
  //       errorStyle: TextStyle(fontSize: 12, color: Colors.red),
  //       border: OutlineInputBorder(),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Color(0xff053EFF)),
  //       ),
  //     ),
  //     dropdownMenuTheme: const DropdownMenuThemeData(
  //       textStyle:
  //           TextStyle(fontSize: 14, color: Colors.black), // Dropdown text
  //       menuStyle: MenuStyle(
  //           // textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14, color: Colors.black)),
  //           ),
  //     ),
  //     // dropdownButtonTheme: DropdownButtonThemeData(
  //     //   style: const TextStyle(fontSize: 14, color: Colors.black), // Default text size
  //     //   dropdownColor: Colors.white,
  //     //   elevation: 2,
  //     // ),
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //         textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //       ),
  //     ),
  //     appBarTheme: const AppBarTheme(
  //       titleTextStyle: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w500,
  //         color: Colors.white,
  //         fontFamily: 'popins',
  //       ),
  //     ),
  //     // elevatedButtonTheme: ElevatedButtonThemeData(
  //     //   style: ElevatedButton.styleFrom(
  //     //     backgroundColor: const Color(0xff053EFF), // Button color
  //     //     textStyle: const TextStyle(
  //     //       color: Colors.white,
  //     //       fontWeight: FontWeight.w500,
  //     //       fontFamily: 'popins',
  //     //     ),
  //     //   ),
  //     // ),
  //     iconTheme: const IconThemeData(color: Colors.black), // Default icon theme
  //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //       backgroundColor: Color(0xff053EFF), // Floating button color
  //       foregroundColor: Colors.white, // Icon color
  //     ),
  //     checkboxTheme: CheckboxThemeData(
  //       fillColor: MaterialStateProperty.all(
  //           const Color(0xff053EFF)), // Checkbox fill color
  //       checkColor: MaterialStateProperty.all(Colors.white), // Check icon color
  //     ),
  //     radioTheme: RadioThemeData(
  //       fillColor: MaterialStateProperty.all(
  //           const Color(0xff053EFF)), // Radio button fill
  //     ),
  //     switchTheme: SwitchThemeData(
  //       thumbColor:
  //           MaterialStateProperty.all(const Color(0xff053EFF)), // Switch thumb
  //       trackColor: MaterialStateProperty.all(
  //           const Color(0xff053EFF).withOpacity(0.5)), // Track color
  //     ),
  //     tabBarTheme: const TabBarTheme(
  //       labelColor: Colors.white, // Selected tab text color
  //       unselectedLabelColor: Colors.black, // Unselected tab text color
  //       indicator: UnderlineTabIndicator(
  //         borderSide: BorderSide(color: Color(0xff053EFF), width: 2),
  //       ),
  //     ),
  //     // inputDecorationTheme: const InputDecorationTheme(
  //     //   filled: true,
  //     //   fillColor: Colors.white,
  //     //   border: OutlineInputBorder(),
  //     //   focusedBorder: OutlineInputBorder(
  //     //     borderSide: BorderSide(color: Color(0xff053EFF)),
  //     //   ),
  //     //   labelStyle: TextStyle(color: Colors.black),
  //     //   hintStyle: TextStyle(color: Colors.grey),
  //     // ),
  //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
  //       backgroundColor: Colors.white,
  //       selectedItemColor: Color(0xff053EFF),
  //       unselectedItemColor: Colors.grey,
  //     ),
  //     sliderTheme: SliderThemeData(
  //       activeTrackColor: Color(0xff053EFF),
  //       inactiveTrackColor: Color(0xff053EFF).withOpacity(0.5),
  //       thumbColor: Color(0xff053EFF),
  //     ),
  //     progressIndicatorTheme: const ProgressIndicatorThemeData(
  //       color: Color(0xff053EFF),
  //     ),
  //     cardTheme: const CardTheme(
  //       color: Colors.white,
  //       elevation: 2,
  //       margin: EdgeInsets.all(8),
  //     ),
  //     dialogTheme: const DialogTheme(
  //       backgroundColor: Colors.white,
  //       titleTextStyle:
  //           TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  //       contentTextStyle: TextStyle(color: Colors.black),
  //     ),
  //   );
  // }

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
                  theme: basicTheme(),
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
                          theme: basicTheme(), // Apply the theme
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
                    theme: basicTheme(), // Apply the theme
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
