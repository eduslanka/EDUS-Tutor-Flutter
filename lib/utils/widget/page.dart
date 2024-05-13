import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/language/language_selection.dart';
import 'package:infixedu/language/translation.dart';
import 'package:infixedu/utils/widget/cc.dart';
import 'package:infixedu/screens/SplashScreen.dart';
import 'package:lottie/lottie.dart';

import '../../controller/InternetController.dart';
import '../../main.dart';
import '../Utils.dart';
import '../error.dart';
import '../theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final LanguageController languageController = Get.put(LanguageController());
  final CustomController controller = Get.put(CustomController());
  bool? isRTL;

  @override
  void initState() {
    super.initState();

    Utils.getIntValue('locale').then((value) {
      setState(() {
        isRTL = value == 0 ? true : false;
        //Utils.showToast('$isRTL');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (_,child) {
            return Obx(() {
              if (controller.isLoading.value) {
                return MaterialApp(
                    builder: EasyLoading.init(),
                    debugShowCheckedModeBanner: false,
                    home: const Scaffold(
                        body: Center(child: CupertinoActivityIndicator())));
              } else {
                if (controller.connected.value) {
                  return isRTL != null
                      ? GetMaterialApp(
                    title: AppConfig.appName,
                    debugShowCheckedModeBanner: false,
                    theme: basicTheme(),
                    locale: langValue ? Get.deviceLocale
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
                          if (snapshot.connectionState == ConnectionState.done) {
                            return const Scaffold(
                              body: Splash(),
                            );
                          }
                          return const CircularProgressIndicator();
                        }),
                  )
                      : const Material(
                      child: Directionality(
                          textDirection: TextDirection.ltr,
                          child:
                          Center(child: CupertinoActivityIndicator())));
                } else {
                  return GetMaterialApp(
                    builder: EasyLoading.init(),
                    locale: langValue
                        ? Get.deviceLocale
                        : Locale(LanguageSelection.instance.val),
                    translations: LanguageController(),
                    fallbackLocale: const Locale('en_US'),
                    debugShowCheckedModeBanner: false,
                    home: internetController.internet.isTrue ? controller.connectedStatus.isTrue ? ErrorPage(message: controller.serverMessage.toString(),) : const ErrorPage() : Center(
                      child: Container(
                        height: Get.height,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/images/no_internet.json'),
                            const Text('Connect with Internet and Restart App.')
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
