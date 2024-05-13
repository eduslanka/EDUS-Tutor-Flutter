// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// ignore: library_prefixes
import 'package:dio/dio.dart' as DIO;
import 'package:get/get.dart';
import 'package:edus_tutor/controller/system_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/exception/DioException.dart';

class Login {
  final String email;
  final String password;

  Login(this.email, this.password);

  Future<String> getLogin(BuildContext context) async {
    bool isSuccess = false;
    dynamic id;
    dynamic rule;
    dynamic schoolId;
    String? image;
    dynamic isAdministrator;
    dynamic token;
    dynamic studentId;
    dynamic message;
    dynamic fullName;
    dynamic phone;

    bool isNullOrEmpty(Object o) => o == null || o == "";

    try {
      DIO.Dio dio = DIO.Dio();
      DIO.Response response =
          await dio.get(InfixApi.login(email, password)).catchError((e) {
        message = DioExceptions.fromDioError(e).toString();
      });
      if (response.statusCode == 200) {
        print('Login Response: ${response.data}');
        var user = response.data;
        isSuccess = user['success'];
        message = user['message'];
        id = user['data']['user']['id'];
        rule = user['data']['user']['role_id'];
        schoolId = user['data']['user']['school_id'];
        isAdministrator = user['data']['user']['is_administrator'];
        token = user['data']['accessToken'];
        fullName = user['data']['user']['full_name'] ?? "";
        phone = user['data']['user']['phone_number'] ?? "";
        if (rule == 2 || rule == "2") {
          studentId = user['data']['userDetails']['s_id'];
        }
        if (rule == 1 || rule == 4 || rule == 5) {
          image = user['data']['userDetails']['staff_photo'] == null
              ? 'public/uploads/staff/demo/staff.jpg'
              : user['data']['userDetails']['staff_photo'].toString();
        } else if (rule == 2) {
          image = user['data']['userDetails']['student_photo'] == null
              ? 'public/uploads/staff/demo/staff.jpg'
              : user['data']['userDetails']['student_photo'].toString();
        } else if (rule == 3) {
          image = user['data']['userDetails']['guardian_photo'] == null || user['data']['userDetails']['guardian_photo'] == ''
              ? 'public/uploads/staff/demo/staff.jpg'
              : user['data']['userDetails']['guardian_photo'].toString();
        }
        if (isSuccess) {
          saveBooleanValue('isLogged', isSuccess);
          saveStringValue('email', email);
          saveStringValue('phone', phone);
          saveStringValue('full_name', fullName);
          saveStringValue('password', password);
          saveStringValue('id', '$id');
          saveStringValue('rule', '$rule');
          saveStringValue('schoolId', '$schoolId');
          saveStringValue('image', image ?? '');
          saveStringValue('isAdministrator', '$isAdministrator');
          saveStringValue('lang', 'en');
          saveStringValue('token', token.toString());

          if (rule == 2 || rule == "2") {
            saveIntValue('studentId', int.parse(studentId.toString()));
          }
          final SystemController _systemController =
              Get.put(SystemController());
          await _systemController.getSystemSettings();
          AppFunction.getFunctions(context, rule.toString());
        }
        return message;
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    return message;
  }

  Future<bool> saveBooleanValue(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(key, value);
  }

  Future<bool> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  Future<bool> saveIntValue(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }
}
