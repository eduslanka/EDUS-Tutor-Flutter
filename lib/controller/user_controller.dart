import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';

import '../model/class_list_model.dart';
import '../model/fee_invoice_model.dart';

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
final Rx<ClassListResponse> _classListResponse=ClassListResponse(success: false, data: ClassListData(classLists: []), message: '',).obs;
 Rx<ClassListResponse> get classListResponse=> _classListResponse;
 
 Future<ClassRecord> fetchStudentFees() async {
    final url = EdusApi.getFeeApi(_studentId.value);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ClassRecord.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }


  Future getStudentRecord() async {
    log('get record ${_studentId.value}');
    try {
      isLoading(true);
      await getIdToken().then((value) async {
        final response = await http.get(
            Uri.parse(EdusApi.studentRecord(_studentId.value)),
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


  Future fetchTodayClasses()async{
   try {
   final  response = await http.post(
      Uri.parse(EdusApi.classList),
      headers: Utils.setHeader(_token.toString()),
    );
    print(EdusApi.todayClass);

    if (response.statusCode == 200) {
      
  classListResponse.value=ClassListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load today classes: ${response.body} ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load today classes: $e');
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
