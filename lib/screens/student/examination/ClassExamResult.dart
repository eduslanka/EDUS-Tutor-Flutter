// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:infixedu/controller/user_controller.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/ClassExam.dart';
import 'package:infixedu/utils/model/ExamRoutineReport.dart';
import 'package:infixedu/utils/model/ExamSchedule.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/widget/ClassExamResultRow.dart';

// ignore: must_be_immutable
class ClassExamResultScreen extends StatefulWidget {
  var id;

  ClassExamResultScreen({Key? key, this.id}) : super(key: key);

  @override
  _ClassExamResultScreenState createState() => _ClassExamResultScreenState();
}

class _ClassExamResultScreenState extends State<ClassExamResultScreen> {
  final UserController _userController = Get.put(UserController());
  Future<ClassExamResultList>? results;
  var id;
  dynamic examId;
  var _selected;
  String? _token;

  Future<ExamSchedule>? examSchedule;
  int? examTypeId;

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records?.first ?? Record();
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        id = widget.id ?? value;

        examSchedule = getStudentExamSchedule(id);

        examSchedule?.then((val) {
          setState(() {
            _selected =
                val.examTypes!.isNotEmpty ? val.examTypes![0].title : '';
            examTypeId = val.examTypes!.isNotEmpty ? val.examTypes![0].id : 0;
            examId =
                getExamCode(val.examTypes ?? [], val.examTypes?[0].title ?? '');
            results = getAllClassExamResult(
              id,
              examTypeId,
              _userController.studentRecord.value.records?.first.id ?? 0,
            );
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log("Exam list :::::::::::::::::::");
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Exam Result'),
      backgroundColor: Colors.white,
      body: FutureBuilder<ExamSchedule>(
        future: examSchedule,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.examTypes!.isNotEmpty) {
              return Column(
                children: <Widget>[
                  getDropdown(snapshot.data?.examTypes ?? []),
                  Expanded(child: getExamResultList()),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget getDropdown(List<ExamType> exams) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: exams.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(
              item.title ?? '',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _userController.selectedRecord.value =
                _userController.studentRecord.value.records?.first ?? Record();
            _selected = value;

            examId = getExamCode(exams, value.toString());
            results = getAllClassExamResult(
              id,
              examId,
              _userController.studentRecord.value.records?.first.id ?? 0,
            );

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<ClassExamResultList> getAllClassExamResult(
      var id, dynamic examId, int recordId) async {
    print(Uri.parse(InfixApi.getStudentClassExamResult(id, examId, recordId)));
    final response = await http.get(
        Uri.parse(InfixApi.getStudentClassExamResult(id, examId, recordId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // return ClassExamResultList.fromJson(jsonData['data']['exam_result']);
      return ClassExamResultList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  int? getExamCode(List<ExamType> exams, String title) {
    int? code;

    for (ExamType exam in exams) {
      if (exam.title == title) {
        code = exam.id;
        break;
      }
    }
    return code;
  }

  Future<ExamSchedule> getStudentExamSchedule(var id) async {
    final response = await http.get(
        Uri.parse(InfixApi.getStudentExamSchedule(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      return examScheduleFromJson(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }

  Widget getExamResultList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StudentRecordWidget(
            onTap: (Record record) {
              _userController.selectedRecord.value = record;
              setState(
                () {
                  results = getAllClassExamResult(
                    id,
                    examId,
                    record.id ?? 0 ?? 0,
                  );
                },
              );
            },
          ),
          Expanded(
            child: FutureBuilder<ClassExamResultList>(
              future: results,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.results.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.results.length + 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == snapshot.data!.results.length) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "Position:${snapshot.data?.position}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w300),
                                    )),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text(
                                        "Total:\n${snapshot.data?.grandTotal}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w300))),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text("Grade:${snapshot.data?.grade}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w300))),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: Text("GPA:${snapshot.data?.gpa}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w300))),
                              ],
                            );
                          }
                          return ClassExamResultRow(
                              snapshot.data?.results[index] ??
                                  ClassExamResult());
                        },
                      );
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
