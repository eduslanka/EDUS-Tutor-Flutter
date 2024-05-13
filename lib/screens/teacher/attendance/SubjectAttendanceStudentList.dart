// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/GlobalClass.dart';
import 'package:infixedu/utils/model/Student.dart';
import 'package:infixedu/utils/widget/ShimmerListWidget.dart';
import 'package:infixedu/utils/widget/SubjectStudentAttendanceRow.dart';

import '../../../utils/model/SubjectAttendance.dart';
import 'subject_attendance_controller.dart';

// ignore: must_be_immutable
class SubjectStudentListAttendance extends StatefulWidget {
  int? classCode;
  int? sectionCode;
  int? subjectCode;
  String? selectedSubject;
  String? url;
  String? date;
  String? token;

  SubjectStudentListAttendance(
      {Key? key, this.classCode,
      this.sectionCode,
      this.subjectCode,
      this.selectedSubject,
      this.url,
      this.date,
      this.token}) : super(key: key);

  @override
  _SubjectStudentListAttendanceState createState() =>
      _SubjectStudentListAttendanceState(
          classCode: classCode,
          sectionCode: sectionCode,
          subjectCode: subjectCode,
          selectedSubject: selectedSubject,
          date: date ?? '',
          url: url ?? '',
          token: token ?? '');
}

class _SubjectStudentListAttendanceState
    extends State<SubjectStudentListAttendance> {
  final SubjectAttendanceController _attendanceController =
      Get.put(SubjectAttendanceController());

  dynamic classCode;
  dynamic sectionCode;
  dynamic subjectCode;
  dynamic selectedSubject;
  String? url;
  Future<StudentList>? students;
  String? date;
  List<String> absent = [];
  int totalStudent = 0;
  var function = GlobalDatae();
  final GlobalKey _key = GlobalKey();
  String? token;
  bool attendanceDone = false;
  String? schoolId;
  bool isLoading = false;
  bool _isHoliday = false;

  Future<SubjectAttendanceList>? newStudents;

  _SubjectStudentListAttendanceState(
      {this.classCode,
      this.sectionCode,
      this.subjectCode,
      this.selectedSubject,
      this.url,
      this.date,
      this.token});

  @override
  void didChangeDependencies() async {
    await Utils.getStringValue('schoolId').then((schoolVal) {
      setState(() {
        schoolId = schoolVal;
        function.setZero();
        newStudents = getAttendance();
        newStudents?.then((value) {
          for (var element in value.attendances) {
            _attendanceController.attendanceMap.addAll({
              '${element.recordId}': SubjectAttendanceValue.fromJson({
                'student': element.sId.toString(),
                'class': element.classId.toString(),
                'section': element.sectionId.toString(),
                'subject': element.subjectId.toString(),
                'attendance_type': element.attendanceType ?? "P",
              })
            });
          }
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _attendanceController.attendanceMap.clear();
    _attendanceController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomAppBarWidget(
        title: '$selectedSubject Attendance',
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              attendanceDone
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Student attendance not done yet".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                            Text(
                              "Select Present/Late/Absent/Halfday".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _isHoliday
                              ? "Attendance Already Submitted As Holiday. Select Unmark holiday to Edit record."
                                  .tr
                              : "Attendance Already Submitted. You Can Edit Record."
                                  .tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 14),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      _isHoliday ? Colors.red : Colors.deepPurpleAccent,
                ),
                onPressed: () async {
                  Map data = {
                    'date': date,
                    'attendance': _attendanceController.attendanceMap,
                  };

                  await newStudents?.then((value) {
                    for (var element in value.attendances) {
                      _attendanceController.attendanceMap.update(
                          '${element.recordId}',
                          (value) => SubjectAttendanceValue.fromJson({
                                'student': element.sId.toString(),
                                'class': element.classId.toString(),
                                'section': element.sectionId.toString(),
                                'subject': element.subjectId.toString(),
                                'attendance_type': _isHoliday ? null : "H",
                              }));
                    }
                    _attendanceController.attendanceMap.forEach((key, value) {
                    });

                    log(data.toString());
                  });

                  await setDefaultAttendance(data);
                },
                child: Text(
                  _isHoliday ? "Unmark Holiday" : "Mark Holiday",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : Expanded(
                  child: FutureBuilder<SubjectAttendanceList>(
                    future: newStudents,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        totalStudent = snapshot.data?.attendances.length ?? 0;
                        return IgnorePointer(
                          ignoring: _isHoliday ? true : false,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data?.attendances.length,
                                  addAutomaticKeepAlives: true,
                                  itemBuilder: (context, index) {
                                    return SubjectStudentAttendanceRow(
                                      snapshot.data?.attendances[index] ?? SubjectAttendance(),
                                      classCode,
                                      sectionCode,
                                      subjectCode,
                                      date ?? '',
                                      token ?? '',
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                margin: const EdgeInsets.only(bottom: 30),
                                padding: const EdgeInsets.only(top: 5),
                                height: 50.0,
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: Utils.gradientBtnDecoration,
                                    child: Text(
                                      "Save".tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(14)),
                                    ),
                                  ),
                                  onTap: () async {
                                    Map data = {
                                      'date': date,
                                      'attendance':
                                          _attendanceController.attendanceMap,
                                    };

                                    _attendanceController.attendanceMap
                                        .forEach((key, value) {
                                    });

                                    await setDefaultAttendance(data);
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Future<SubjectAttendanceList> getAttendance() async {
    final response = await http.get(
        Uri.parse(InfixApi.subjectattendanceCheck(
            widget.date ?? '', classCode, sectionCode, subjectCode)),
        headers: Utils.setHeader(token ?? ''));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData['message'] == 'Student attendance not done yet') {
        setState(() {
          attendanceDone = true;
        });
      }

      final data = SubjectAttendanceList.fromJson(jsonData['data']);

      if(data.attendances.isNotEmpty){
        if (data.attendances.first.attendanceType == "H") {
          setState(() {
            _isHoliday = true;
          });
        } else {
          setState(() {
            _isHoliday = false;
          });
        }
        if (data.attendances.first.attendanceType == null) {
          setState(() {
            attendanceDone = true;
          });
        } else {
          setState(() {
            attendanceDone = false;
          });
        }
      }

      return data;
    } else {
      throw Exception('Failed to load');
    }
  }

  void sentNotificationToSection() async {
    final response = await http.get(Uri.parse(
        InfixApi.sentNotificationToSection('Attendance', 'Attendance sunmitted',
            '$classCode', '$sectionCode')));
    if (response.statusCode == 200) {}
  }

  Future setDefaultAttendance(Map data) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
        Uri.parse(InfixApi.subjectattendanceDefaultSent),
        headers: Utils.setHeader(token ?? ''),
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      newStudents = getAttendance();
      // CustomSnackBar().snackBarSuccess("${jsonString['message'].toString()}");
      setState(() {
        attendanceDone = false;
        isLoading = false;
      });
      debugPrint('Attendance default successful');
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load');
    }
  }
}
