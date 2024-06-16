import 'dart:async';
import 'dart:convert';

import 'package:edus_tutor/app_service/app_service.dart';
import 'package:edus_tutor/model/quets_model.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/SystemSettings.dart';
import 'package:http/http.dart' as http;

import '../model/teacher_today_class_model.dart';
import '../model/today_class_model.dart';

class SystemController extends GetxController {

  Rx<SystemSettings> systemSettings = SystemSettings().obs;
  Rx<Quote> quote=Quote().obs;
 Rx<TodayClassResponse> todayClassResponse=TodayClassResponse(success: false, classes: []).obs;
  Rx<TeacherTodayClassResponse> teacherTodayClassResponse=TeacherTodayClassResponse(success: false, classes: []).obs;
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
            Uri.parse(EdusApi.generalSettings + '/$schoolId'),
            headers: Utils.setHeader(_token.toString()));
print(EdusApi.generalSettings + '/$schoolId');
        if (response.statusCode == 200) {
          final studentRecords = systemSettingsFromJson(response.body);
          systemSettings.value = studentRecords;

          isLoading(false);
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
  
  quote.value=  await fetchQuoteOfTheDay();
 // response.value=await fetchTodayClasses(_token.toString());
  Utils.getStringValue('rule').then((value) {
      _rule.value = value??'';
      if(value=='2'){
          fetchTodayClasses();
      }else if(value=='4'){
fetchTeacherTodayClasses();
      }
    });
    } catch (e, t) {
      isLoading(false);
      print('From e: $e');
      print('From t: $t');
      throw Exception('failed to load');
    }
  }
String hardCodeToken='Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmM5YjM5MGY1Njg2NWM0MzllNGJhMDZhZDc3OWM2MGY4ZjM2Y2Y4YTBiNTdhNmMyZTczODhlY2IxOGNhZTBjNzIyNGYyMzhlYjg0Njk3YmUiLCJpYXQiOjE3MTczMjk4OTAuMzU3NDY0LCJuYmYiOjE3MTczMjk4OTAuMzU3NDY3LCJleHAiOjE3NDg4NjU4OTAuMzU0ODYzLCJzdWIiOiIyMyIsInNjb3BlcyI6W119.WsXvgtV9EDLMv8XXPN69jYhdtFJRJm5n1mDxZOP7Qh4cQqXvAJMYhjAh63RAt7KHn6Wj3fhT4QGCMk8Su-_1_1Oqlqq8KT6ByquAQFFIAaB5GsX3WdTswfFTgqR-rGHZHGM1GDD1MlQ7IDdtWUCLCMhS8oNgPim3P0KtarO0a1mNwsZvihe9r8S2dIR367X7qkquzsDZuzdoVLu7n5GPPb-DVMjSj9KkWII3rr3DuPYb-AQApVgaytlj1OdPW6SC-GemYiqVeWhYjfG0Nl1pO3cTFZTFTBNsNGsldGJ6XmaIRuFl9BCxra14WYAAgJUH1ZCmtS_Mw2NPFKD66_vPtHflgF70nRnbcdz8ag2AZB-ZwzTH9pL75cgjsyRYf4WEJRoCuU1NBSDpNjrjwKQvvwc9f8arEp7QRRiVM5pM5wfT2l1B-Ybxl4EM4sdTxsjAH8yiCxJmNX-i32h2_kRCdDZOmJ_yUD8cvCxhtgD6Z37-MEIkoWH3wGXEc325_JfUCZhzI9GI-r7We124xiGHMEinHMstmzBtizTugPfEuGVSGg0rrWXbUIMx4z4Z63F-SA0FS0rndCqa2zyFgb1pRSJT76CrB6Gs-2wjtUgjxN8SaD_GS0AKA1cwQPilL1Edge9vM12CteGryTM4JZ29x5LwN4YyBOW6lbWMaxqY8Aw';
Future fetchTodayClasses()async{
   try {
 await getSchoolId().then((value) async {

   final  response =  await http.post(
      Uri.parse( EdusApi.todayClass),
      headers: Utils.setHeader(_token.toString()),
    );
   

    if (response.statusCode == 200) {
      
  todayClassResponse.value=TodayClassResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load today classes: ${response.body} ${response.statusCode}');
    }
 });
  
  } catch (e) {
    throw Exception('Failed to load today classes: $e');
  }
}

  Future fetchTeacherTodayClasses()async{
   try {

   final  response = await http.get(
      Uri.parse( EdusApi.todayClassTecher),
      headers: Utils.setHeader(_token.toString()),
    );
   print(EdusApi.todayClassTecher);
   print(_token.toString());

    if (response.statusCode == 200) {
      
  teacherTodayClassResponse .value=TeacherTodayClassResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load today classes: ${response.body} ${response.statusCode}');
    }
  } catch (e,t) {
    print('trace tree $t');
    throw Exception('Failed to load today classes: $e');
  }
}

 
  Future getSchoolId() async {
    await Utils.getStringValue('schoolId').then((value) async {
      _schoolId.value = value ?? '';
      await Utils.getStringValue('token').then((value) async {
        _token.value = value ?? '';
      });
    });
  }
Rx<String> _rule=''.obs;
Rx<String> get rule=>_rule;
  @override
  void onInit() {
    getSystemSettings();
  //  fetchTodayClasses();
    super.onInit();
    
  }
}
