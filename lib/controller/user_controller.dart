import 'dart:developer';

import 'package:get/get.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';

class UserController extends GetxController {
  final Rx<int> _studentId = 0.obs;

  Rx<int> get studentId => _studentId;

  final Rx<String> _token = "".obs;

  Rx<String> get token => _token;

  final Rx<String> _schoolId = "".obs;

  Rx<String> get schoolId => _schoolId;

  final Rx<String> _role = "".obs;

  Rx<String> get role => _role;

  Rx<bool> isLoading = false.obs;

  final Rx<StudentRecords> _studentRecord = StudentRecords().obs;

  Rx<StudentRecords> get studentRecord => _studentRecord;

  Rx<Record> selectedRecord = Record().obs;

  Future getStudentRecord() async {
    log('get record ${_studentId.value}');
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(InfixApi.studentRecord(_studentId.value)),
            headers: Utils.setHeader(_token.toString()));

        if (response.statusCode == 200) {
          print('Body: ${response.body}');
          final studentRecords = studentRecordsFromJson(response.body);
          _studentRecord.value = studentRecords;
          if (_studentRecord.value.records!.isNotEmpty) {
            selectedRecord.value = _studentRecord.value.records?.first ?? Record();
          }

          isLoading(false);
        } else {
          isLoading(false);
          throw Exception('failed to load');
        }
      });
    } catch (e, t) {
      print('From T: $t');
      print('From E: $e');
      isLoading(false);
      throw Exception('failed to load $e');
    }
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value ?? '';
      await Utils.getStringValue('rule').then((ruleValue) {
        _role.value = ruleValue ?? '';
      }).then((value) async {
        if (_role.value == "2") {
          await Utils.getIntValue('studentId').then((studentIdVal) {
            _studentId.value = studentIdVal ?? 0;
          });
        }
        await Utils.getStringValue('schoolId').then((schoolIdVal) {
          _schoolId.value = schoolIdVal ?? '';
        });
      });
    });
  }
}
