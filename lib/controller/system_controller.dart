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
  Rx<TeacherTodayClassResponse> teacherTodayClassResponse=TeacherTodayClassResponse(success: false, data: TodayClassData(todayClass: []), message: '', ).obs;
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
