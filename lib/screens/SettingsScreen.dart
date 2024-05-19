import 'package:edus_tutor/config/app_size.dart';
import 'package:edus_tutor/webview/launch_webview.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/language/language_selection.dart';
import 'package:edus_tutor/language/translation.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'ChangePassword.dart';
import 'contact_us.dart';

class SettingScreen extends StatefulWidget {
  
  const SettingScreen({Key? key, }) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final LanguageController languageController = Get.put(LanguageController());

  List<bool> isSelected = [false, false];
  final GlobalKey _scaffold = GlobalKey();
String _fullName='';
String _id='XXXX';
  @override
  void initState() {
    super.initState();
    Utils.getIntValue('locale').then((value) {
      setState(() {
        // ignore: unnecessary_statements
        value != null ? isSelected[value] = true : null;
        //Utils.showToast('$value');
      });
    });
     Utils.getStringValue('full_name').then((value) {
      setState(() {
        _fullName=value??'Mr/s x';
      });
      
    });
     Utils.getStringValue('id').then((value) {
      setState(() {
        _id=value??'XXXX';
      });
      
    });
    print(_fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'More'.tr),
      backgroundColor: Colors.white,
      key: _scaffold,
      body: ListView(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Card(
          //     child: Padding(
          //       padding: EdgeInsets.only(bottom: 10.0),
          //       child: toggleButton(context),
          //     ),
          //     elevation: 5.0,
          //   ),
          // ),
    //      BottomLine(),
          // const SizedBox(
          //   height: 10,
          // ),
          h16,
          // ListTile(
          //   onTap: () {
          //     showChangeLanguageAlert(_scaffold.currentContext!);
          //     // if (_scaffold.currentContext != null) {
          //     //   showChangeLanguageAlert(context);
          //     // }
          //   },
          //   leading: CircleAvatar(
          //     backgroundColor: Colors.blueAccent,
          //     child: Icon(
          //       Icons.language,
          //       color: Colors.white,
          //       size: ScreenUtil().setSp(16),
          //     ),
          //   ),
          //   title: Text(
          //     'Change Language'.tr,
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          //   trailing: GetBuilder<LanguageController>(
          //       init: LanguageController(),
          //       builder: (controller) {
          //         return Container(
          //             decoration: BoxDecoration(
          //                 color: Colors.redAccent,
          //                 borderRadius: BorderRadius.circular(8)),
          //             child: Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Text(
          //                 controller.langName.value,
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .titleLarge
          //                     ?.copyWith(color: Colors.white),
          //               ),
          //             ));
          //       }),
          //   dense: true,
          // ),
          // const BottomLine(),
          ListTile(
            onTap: () {
              Navigator.of(context).push(ScaleRoute(page: const ChangePassword()));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.lock,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Change Password'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            dense: true,
          ),h16,
          ListTile(
            onTap: () {
              Navigator.of(context).push(ScaleRoute(page:  HelpDeskMenu(stName: _fullName, stId: _id,) ));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.contact_page,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Help Desk'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            dense: true,
          ),
       //   const BottomLine(),
        h16,
          ListTile(
            onTap: () {
              Navigator.of(context).push(ScaleRoute(page: const LaunchWebView(launchUrl: 'https://edustutor.com/terms-conditions/',title: 'Terms & Conditions',)));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.note_alt,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Terms & Conditions'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            dense: true,
          ),
       //   const BottomLine(),
        h16,
          ListTile(
            onTap: () {
              Navigator.of(context).push(ScaleRoute(page: const LaunchWebView(launchUrl: 'https://edustutor.com/privacy-policy/',title: 'Privacy Policy',)));
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                Icons.security,
                color: Colors.white,
                size: ScreenUtil().setSp(16),
              ),
            ),
            title: Text(
              'Privacy Policy'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            dense: true,
          ),
      //    const BottomLine(),
       h16,
 
     //     const BottomLine(),
      
         
          // ListTile(
          //   onTap: () {
          //     Get.dialog(
          //       AccountDeleteDialogue(
          //         onYesTap: () {
          //           Get.back();
          //           settingsController.deleteAccount(context);
          //           // settingsController.deleteAccount(context).then((value) => Navigator.pop(context));
          //         },
          //       ),
          //       // backgroundColor: Colors.white,
          //     );
          //   },
          //   leading: CircleAvatar(
          //     backgroundColor: Colors.blueAccent,
          //     child: Icon(
          //       Icons.delete,
          //       color: Colors.white,
          //       size: ScreenUtil().setSp(16),
          //     ),
          //   ),
          //   title: Text(
          //     'Account Delete'.tr,
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          //   dense: true,
          // ),
          // const BottomLine(),

        ],
      ),
    );
  }

  Widget toggleButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'System Locale',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ToggleButtons(
            borderColor: Color(0xff053EFF),
            fillColor: Color(0xff053EFF),
            borderWidth: 2,
            selectedBorderColor: Color(0xff053EFF),
            selectedColor: Colors.white,
            borderRadius: BorderRadius.circular(0),
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'RTL',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'popins',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'LTL',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'popins',
                  ),
                ),
              ),
            ],
            onPressed: (int index) {
              setState(() {
                Utils.saveIntValue('locale', index);
                rebuildAllChildren(context);
                for (int i = 0; i < isSelected.length; i++) {
                  if (i == index) {
                    isSelected[i] = true;
                  } else {
                    isSelected[i] = false;
                  }
                }
              });
            },
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  showChangeLanguageAlert(BuildContext context) {
    Get.bottomSheet(
      GetBuilder<LanguageController>(
          init: LanguageController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xffDADADA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: languages.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              debugPrint(languages[index].languageValue);
                              LanguageSelection.instance.drop =
                                  languages[index].languageValue;
                              final sharedPref =
                                  await SharedPreferences.getInstance();
                              sharedPref.setString(
                                  'language', languages[index].languageValue ?? '');
                              controller.appLocale =
                                  languages[index].languageValue;
                              Get.updateLocale(
                                  Locale(controller.appLocale.toString()));
                              setState(() {
                                LanguageSelection.instance.drop =
                                    languages[index].languageValue;
                                for (var element in languages) {
                                  if (element.languageValue ==
                                      languages[index].languageValue) {
                                    LanguageSelection.instance.langName =
                                        element.languageText ?? '';
                                  }
                                }
                                languageController.langName.value =
                                    LanguageSelection.instance.langName;
                              });
                            },
                            child: Text(
                              languages[index].languageText.toString(),
                              style: Get.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const Divider(),
                  // ListTile(
                  //   contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  //   title: DropdownButton(
                  //     isExpanded: true,
                  //     items: List.generate(
                  //       languages.length,
                  //       (index) => DropdownMenuItem(
                  //         child: Text(
                  //           languages[index].languageText,
                  //           style: Theme.of(context).textTheme.headlineSmall,
                  //         ),
                  //         value: languages[index].languageValue,
                  //       ),
                  //     ),
                  //     onChanged: (value) async {
                  //       print(value);
                  //       LanguageSelection.instance.drop = value;
                  //       final sharedPref =
                  //           await SharedPreferences.getInstance();
                  //       sharedPref.setString('language', value);
                  //       controller.appLocale = value;
                  //       Get.updateLocale(
                  //           Locale(controller.appLocale.toString()));
                  //       setState(() {
                  //         LanguageSelection.instance.drop = value;
                  //         languages.forEach((element) {
                  //           if (element.languageValue == value) {
                  //             LanguageSelection.instance.langName =
                  //                 element.languageText;
                  //           }
                  //         });
                  //         languageController.langName.value =
                  //             LanguageSelection.instance.langName;
                  //       });
                  //     },
                  //     value: LanguageSelection.instance.drop,
                  //   ),
                  // ),
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                ],
              ),
            );
          }),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
    );

    // showDialog<void>(
    //   barrierDismissible: true,
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: <Widget>[
    //         Padding(
    //           padding: const EdgeInsets.all(0),
    //           child: Container(
    //             height: MediaQuery.of(context).size.height / 3,
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.white,
    //             child: Padding(
    //               padding:
    //                   const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
    //               child: ListView.builder(
    //                 itemCount: languagesList.length,
    //                 itemBuilder: (context, index) {
    //                   return Column(
    //                     children: <Widget>[
    //                       GestureDetector(
    //                         onTap: () {
    //                           Utils.saveStringValue(
    //                               'lang', languagesMap[languagesList[index]]);
    //                           application.onLocaleChanged(
    //                               Locale(languagesMap[languagesList[index]]));
    //                           rebuildAllChildren(context);
    //                         },
    //                         child: Text(
    //                           languagesList[index],
    //                           style: Theme.of(context).textTheme.headlineSmall,
    //                         ),
    //                       ),
    //                       BottomLine(),
    //                     ],
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void rebuildAllChildren(BuildContext context) {
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (BuildContext context) {
//      return MyApp();
    Route route = MaterialPageRoute(builder: (context) => const MyApp());
    Navigator.pushAndRemoveUntil(context, route, ModalRoute.withName('/'));
  }
}
