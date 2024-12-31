import 'dart:convert';

import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../../../app_service/app_service.dart';
import '../../../../../utils/Utils.dart';
import '../../../../../utils/model/student_user_model.dart';
import '../model/student_record_model.dart';
import 'package:http/http.dart' as http;

class RecordedClassController extends GetxController {
  final String baseUrl;
  RecordedClassController({required this.baseUrl});

  var isLoading = false.obs;
  var recordedClasses = <RecordedClass>[].obs;
  var errorMessage = ''.obs;
  var isAllow = false.obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchRecordedClasses();
    check();
  }

  Future<void> check() async {
    isAllow.value = await isAllowTheUser();
  }

  Future<bool> isAllowTheUser() async {
    try {
      final email = await Utils.getStringValue('email');
      final password = await Utils.getStringValue('password');
      final response = await http.post(
        Uri.parse(EdusApi.login),
        body: {
          'email': email,
          'password': password,
        },
      );
      print(response.body);
      final user = StudentModel.fromJson(jsonDecode(response.body));
      // await Utils.saveStringValue('edNo', user.user.);
      await Utils.saveBooleanValue(Utils.isAllowKey,
          user.user.activeStatus == 1 && user.studentHaveDueFees == false);
      return user.user.activeStatus == 1 && user.studentHaveDueFees == false;
    } catch (e, t) {
      print(e);
      print(t);
      await Utils.saveBooleanValue(Utils.isAllowKey, false);
      return false;
    }
  }

  Future<void> fetchRecordedClasses() async {
    try {
      isLoading(true);
      print('${EdusApi.baseApi}student-recorded-class');
      final token = await Utils.getStringValue('token');
      final response = await http.post(
          Uri.parse('https://app.edustutor.com/api/student-recorded-class'),
          headers: Utils.setHeader(token.toString()));
      print(response.body);
      if (response.statusCode == 200) {
        // Parse the response and update the list of recorded classes
        var data =
            RecordedClassListResponse.fromJson(json.decode(response.body));
        recordedClasses.value = data.recordedClasses;
      } else {
        errorMessage.value = 'Failed to load data: ${response.body}';
      }
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}
