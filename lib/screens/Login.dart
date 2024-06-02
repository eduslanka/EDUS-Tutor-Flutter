import 'dart:async';
import 'dart:convert';

import 'package:edus_tutor/config/app_size.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/server/LoginService.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter_svg/flutter_svg.dart';

import '../webview/launch_webview.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? user;
  String? email;
  Future<String>? futureEmail;
  String password = '123456';
  bool isResponse = false;
  bool obscurePass = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleLarge;

    return WillPopScope(
      onWillPop: () async => !(Navigator.of(context).userGestureInProgress),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: screenHeight(400, context),
                  decoration: BoxDecoration(
                   // color: Color(0xff053EFF),
                      image: DecorationImage(
                    image: AssetImage(AppConfig.loginBackground),
                    fit: BoxFit.cover,
                  )),
                  child: Center(
                    child: Container(
                      height: 150.0,
                      width: 150.0,
                      margin: const EdgeInsets.only(bottom: 80),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(AppConfig.appLogo),
                      )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AppConfig.isDemo
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.h),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  user = 'student';
                                  futureEmail = getEmail(user ?? '');
                                  futureEmail?.then((value) {
                                    setState(() {
                                      email = value;
                                      emailController.text = email ?? '';
                                      passwordController.text = password;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff053EFF),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    )),
                                child: Text(
                                  "Student",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    user = 'teacher';
                                    futureEmail = getEmail(user ?? '');
                                    futureEmail?.then((value) {
                                      setState(() {
                                        email = value;
                                        emailController.text = email ?? '';
                                        passwordController.text = password;
                                      });
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff053EFF),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0.0),
                                      ),
                                    )),
                                child: Text("Teacher",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white)),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  user = 'parent';
                                  futureEmail = getEmail(user ?? '');
                                  futureEmail?.then((value) {
                                    setState(() {
                                      email = value;
                                      emailController.text = email ?? '';
                                      passwordController.text = password;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff053EFF),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0),
                                      ),
                                    )),
                                child: Text("Parents",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.h, 0, 10.h, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    style: textStyle,
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Email".tr,
                      labelText: "Email".tr,
                      labelStyle: textStyle,
                      errorStyle:
                          const TextStyle(color: Colors.blue, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: const Icon(
                        Icons.email,
                        size: 24,
                        color: Color.fromRGBO(142, 153, 183, 0.5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.h, 10.h, 10.h, 0),
                  child: TextFormField(
                    obscureText: obscurePass,
                    keyboardType: TextInputType.visiblePassword,
                    style: textStyle,
                    controller: passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter a valid password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Password".tr,
                      labelText: "Password".tr,
                      labelStyle: textStyle,
                      errorStyle:
                          const TextStyle(color: Colors.blue, fontSize: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            obscurePass = !obscurePass;
                          });
                        },
                        child: Icon(
                          obscurePass ? Icons.lock_rounded : Icons.lock_open,
                          size: 24,
                          color: const Color.fromRGBO(142, 153, 183, 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: Utils.gradientBtnDecoration,
                  child: Text(
                    "Login".tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    String email = emailController.text;
                    String password = passwordController.text;

                    if (email.isNotEmpty && password.isNotEmpty) {
                      setState(() {
                        isResponse = true;
                      });
                      Login(email, password).getLogin(context).then((result) {
                        setState(() {
                          isResponse = false;
                        });
                        Utils.showToast(result);
                      });
                    } else {
                      setState(() {
                        isResponse = false;
                      });
                      Utils.showToast('invalid email and password');
                    }
                  }
                },
              ),
           h16,
           registerButton(),
            h16,
             contactUs(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isResponse == true
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                      )
                    : const Text(''),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Widget registerButton() {
    return GestureDetector(
      onTap: (){
        Route route;
          route = MaterialPageRoute(builder: (context) => const LaunchWebView(launchUrl: 'https://edustutor.com/register/',title: 'Register',));
            Navigator.push(context, route);
      },
      child: Container(
        width: double.infinity,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account ?',style: TextStyle(color: Colors.black),),
              Text('  Register Now',style: TextStyle(color: Color(0xff053EFF)),),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getEmail(String user) async {
    final response = await http.get(Uri.parse(EdusApi.getEmail));
    debugPrint(EdusApi.getEmail);
    debugPrint(response.body);
    var jsonData = json.decode(response.body);

    //print(InfixApi.getDemoEmail(schoolId));

    return jsonData['data'][user]['email'];
  }
  Widget contactUs(){
  return Column(children: [
    const Text('Trouble to login ?   Contact Us'),
    h16,
    Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.center,
      children: [
      GestureDetector(
        onTap: (){
          // var url = Uri.parse('https://wa.me/+94774487774?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
          UrlLauncher.launch('https://wa.me/+94701677488?text=👋 Hi, I would like to join EDUS Classes. Please help me to register as a student.');
        },
        child: SvgPicture.asset('assets/config/whats-app-whatsapp-whatsapp-icon-svgrepo-com.svg',height: 30,width: 40,)),
      w16,
      GestureDetector(
        onTap: (){
          UrlLauncher.launch("tel:+94701677488");
        },
        child: SvgPicture.asset('assets/config/phone-call-svgrepo-com.svg',height: 30,width: 40,))
    ],)
  ],);
}

}
