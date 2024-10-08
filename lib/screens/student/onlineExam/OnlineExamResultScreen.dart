// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:edus_tutor/controller/user_controller.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/StudentRecordWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/ONlineExamResult.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:edus_tutor/utils/widget/OnlineExamResultRow.dart';

// ignore: must_be_immutable
class OnlineExamResultScreen extends StatefulWidget {
  var id;

  OnlineExamResultScreen({super.key, this.id});

  @override
  _OnlineExamResultScreenState createState() => _OnlineExamResultScreenState();
}

class _OnlineExamResultScreenState extends State<OnlineExamResultScreen> {
  final UserController _userController = Get.put(UserController());
  Future<OnlineExamResultList>? results;
  var id;
  dynamic code;
  var _selected;
  Future<OnlineExamNameList>? exams;
  String? _token;

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
        exams = getAllOnlineExam(
            id, _userController.studentRecord.value.records?.first.id ?? 0);
        exams?.then((val) {
          _selected = val.names.isNotEmpty ? val.names[0].title : '';
          code = val.names.isNotEmpty ? val.names[0].id : 0;
          results = getAllOnlineExamResult(id, code,
              _userController.studentRecord.value.records?.first.id ?? 0);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Result'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentRecordWidget(
              onTap: (Record record) async {
                _userController.selectedRecord.value = record;
                setState(
                  () {
                    exams = getAllOnlineExam(id, record.id ?? 0);
                    exams?.then((val) {
                      _selected =
                          val.names.isNotEmpty ? val.names[0].title : '';
                      code = val.names.isNotEmpty ? val.names[0].id : 0;
                      results =
                          getAllOnlineExamResult(id, code, record.id ?? 0);
                    });
                  },
                );
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: FutureBuilder<OnlineExamNameList>(
                future: exams,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.names.isNotEmpty) {
                      return Column(
                        children: <Widget>[
                          getDropdown(snapshot.data?.names ?? []),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Expanded(child: getExamResultList())
                        ],
                      );
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getDropdown(List<OnlineExamName> names) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: names.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Text(
              item.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selected = value;

            code = getExamCode(names, value.toString());
            results = getAllOnlineExamResult(
                id, code, _userController.selectedRecord.value.id ?? 0);

            getExamResultList();
          });
        },
        value: _selected,
      ),
    );
  }

  Future<OnlineExamResultList> getAllOnlineExamResult(
      var id, dynamic code, int recordId) async {
    final response = await http.get(
        Uri.parse(EdusApi.getStudentOnlineActiveExamResult(id, code, recordId)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamResultList.fromJson(jsonData['data']['exam_result']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<OnlineExamNameList> getAllOnlineExam(var id, int recordId) async {
    final response = await http.get(
        Uri.parse(EdusApi.getStudentOnlineActiveExamName(id, recordId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return OnlineExamNameList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  dynamic getExamCode(List<OnlineExamName> names, String title) {
    dynamic code;
    for (OnlineExamName name in names) {
      if (name.title == title) {
        code = name.id;
        break;
      }
    }
    return code;
  }

  Widget getExamResultList() {
    return FutureBuilder<OnlineExamResultList>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data!.results.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data?.results.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return OnlineExamResultRow(
                    snapshot.data?.results[index] ?? OnlineExamResult());
              },
            );
          } else {
            return Utils.noDataWidget();
          }
        } else {
          return const Center(child: CupertinoActivityIndicator());
        }
      },
    );
  }
}
