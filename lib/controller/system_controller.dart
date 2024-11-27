import 'dart:async';
import 'dart:convert';

import 'package:edus_tutor/app_service/app_service.dart';
import 'package:edus_tutor/model/quets_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/SystemSettings.dart';
import 'package:http/http.dart' as http;

import '../model/teacher_today_class_model.dart';
import '../model/today_class_model.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_review/in_app_review.dart';

class SystemController extends GetxController {
  Rx<SystemSettings> systemSettings = SystemSettings().obs;
  Rx<Quote> quote = Quote().obs;
  Rx<TodayClassResponse> todayClassResponse =
      TodayClassResponse(success: false, classes: []).obs;
  Rx<bool> isAllow = true.obs;
  Rx<TeacherTodayClassResponse> teacherTodayClassResponse =
      TeacherTodayClassResponse(
    success: false,
    data: TodayClassData(todayClass: []),
    message: '',
  ).obs;
  Rx<bool> isLoading = false.obs;

  final Rx<String> _token = "".obs;

  Rx<String> get token => _token;

  final Rx<String> _schoolId = "".obs;

  Rx<String> get schoolId => _schoolId;

  Future getSystemSettings() async {
    try {
      isLoading(true);
      await getSchoolId().then((value) async {
        final response = await http.get(
            Uri.parse('${EdusApi.generalSettings}/$schoolId'),
            headers: Utils.setHeader(_token.toString()));

        if (response.statusCode == 200) {
          final studentRecords = systemSettingsFromJson(response.body);
          systemSettings.value = studentRecords;

          isLoading(false);
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });

      quote.value = await fetchQuoteOfTheDay();
      // response.value=await fetchTodayClasses(_token.toString());
      Utils.getStringValue('rule').then((value) async {
        _rule.value = value ?? '';
        if (value == '2') {
          await fetchTodayClasses();
        } else if (value == '4') {
          await fetchTeacherTodayClasses();
        }
      });
    } catch (e, t) {
      isLoading(false);
      debugPrint('From e: $e');
      debugPrint('From t: $t');
      throw Exception('failed to load');
    }
  }

  Future<void> checkForUpdate() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }

  Future fetchTodayClasses() async {
    try {
      await getSchoolId().then((value) async {
        final response = await http.post(
          Uri.parse(EdusApi.todayClass),
          headers: Utils.setHeader(_token.toString()),
        );

        if (response.statusCode == 200) {
          todayClassResponse.value =
              TodayClassResponse.fromJson(json.decode(response.body));
        } else {
          todayClassResponse.value =
              TodayClassResponse(success: false, classes: []);
          //  throw Exception(
          //  'Failed to load today classes: ${response.body} ${response.statusCode}');
        }
      });
    } catch (e, t) {
      todayClassResponse.value =
          TodayClassResponse(success: false, classes: []);
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
  }

  Future fetchTeacherTodayClasses() async {
    try {
      final response = await http.get(
        Uri.parse(EdusApi.todayClassTecher),
        headers: Utils.setHeader(_token.toString()),
      );

      if (response.statusCode == 200) {
        print(response.body);
        teacherTodayClassResponse.value =
            TeacherTodayClassResponse.fromJson(json.decode(response.body));
      } else {
        teacherTodayClassResponse.value = TeacherTodayClassResponse(
            success: false, data: TodayClassData(todayClass: []), message: '');
        throw Exception(
            'Failed to load today classes: ${response.body} ${response.statusCode}');
      }
    } catch (e, t) {
      teacherTodayClassResponse.value = TeacherTodayClassResponse(
          success: false, data: TodayClassData(todayClass: []), message: '');
      debugPrint('trace tree $t');
      //throw Exception('Failed to load today classes: $e');
    }
  }

  Future<void> check() async {
    isAllow.value = await isAllowTheUser();
  }

  Future getSchoolId() async {
    await Utils.getStringValue('schoolId').then((value) async {
      _schoolId.value = value ?? '';
      await Utils.getStringValue('token').then((value) async {
        _token.value = value ?? '';
      });
    });
  }

  final Rx<String> _rule = ''.obs;
  Rx<String> get rule => _rule;
  @override
  void onInit() {
    getSystemSettings();
    if (!kDebugMode) {
      checkForUpdate();
    }
    check();
    //  fetchTodayClasses();
    super.onInit();
  }
}
