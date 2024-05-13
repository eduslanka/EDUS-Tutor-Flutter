// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/student/SubjectStudentAttendance.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/Subject.dart';

// Project imports:
import '../../../utils/model/StudentAttendance.dart';
import '../../../utils/model/StudentRecord.dart';
import '../../../utils/widget/ScaleRoute.dart';
import '../../../utils/widget/SubjectRowLayout.dart';

// ignore: must_be_immutable
class StudentSubjectListScreen extends StatefulWidget {
  dynamic id;
  String? schoolId;
  var token;
  dynamic subjectCode;

  StudentSubjectListScreen(
      {Key? key, this.id, this.token, this.schoolId, this.subjectCode}) : super(key: key);

  @override
  _StudentSubjectListScreenState createState() =>
      _StudentSubjectListScreenState(
          id: id, token: token, schoolId: schoolId ?? '', subjectCode: subjectCode);
}

class _StudentSubjectListScreenState extends State<StudentSubjectListScreen> {
  final UserController _userController = Get.put(UserController());
  Future<SubjectList>? subjects;

  var id;
  String? token;
  String? schoolId;
  Future<StudentAttendanceList>? attendances;
  var subjectCode;
  _StudentSubjectListScreenState(
      {this.id, this.token, this.schoolId, this.subjectCode});

  dynamic subjectId;

  dynamic classId;
  dynamic sectionId;
  String? url;

  bool isLoading = false;

  int? a;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      token = value;
    });
    Utils.getStringValue('schoolId').then((value) {
      schoolId = value;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records?.first ?? Record();
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = value;
        subjects = getAllSubject(
            widget.id != null ? int.parse(widget.id) : int.parse(value ?? ''),
            _userController.studentRecord.value.records?.first.id ?? 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(title: 'Select Subject'),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    itemBuilder: (context, recordIndex) {
                      Record record = _userController
                          .studentRecord.value.records?[recordIndex] ?? Record();
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          _userController.selectedRecord.value = record;
                          setState(
                            () {
                              subjects = getAllSubject(
                                  widget.id != null
                                      ? int.parse(widget.id)
                                      : int.parse(id),
                                  record.id ?? 0 ?? 0);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color:
                                  _userController.selectedRecord.value == record
                                      ? Colors.transparent
                                      : Colors.grey,
                            ),
                            gradient:
                                _userController.selectedRecord.value == record
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xff7C32FF),
                                          Color(0xffC738D8),
                                        ],
                                      )
                                    : const LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                        ],
                                      ),
                          ),
                          child: Text(
                            "${record.className} (${record.sectionName})",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              color:
                                  _userController.selectedRecord.value == record
                                      ? Colors.white
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _userController.studentRecord.value.records?.length ?? 0,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('Subject'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Teacher'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Text('Type'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: ScreenUtil().setSp(16),
                                          fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder<SubjectList>(
                        future: subjects,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.subjects.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.subjects.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: (() {
                                      a = snapshot.data?.subjects[index].subjectId;
                                      String? subjectName = snapshot
                                          .data?.subjects[index].subjectName;
                                      Navigator.push(
                                          context,
                                          ScaleRoute(
                                              page:
                                                  SubjectStudentAttendanceScreen(
                                            id: widget.id,
                                            token: token,
                                            subjectCode: subjectCode = a,
                                            subjectName: subjectName,
                                          )));
                                    }),
                                    child: SubjectRowLayout(
                                        snapshot.data?.subjects[index] ?? Subject()),
                                  );
                                },
                              );
                            } else {
                              return Utils.noDataWidget();
                            }
                          } else {
                            return const Center(child: CupertinoActivityIndicator());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<SubjectList> getAllSubject(int id, int recordId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSubjectsUrl(id, recordId)),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SubjectList.fromJson(jsonData['data']['student_subjects']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
