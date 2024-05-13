// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentHomework.dart';
import 'package:infixedu/utils/widget/TeacherHomeworkRow.dart';

class TeacherHomework extends StatefulWidget {
  const TeacherHomework({Key? key}) : super(key: key);

  @override
  _TeacherHomeworkState createState() => _TeacherHomeworkState();
}

class _TeacherHomeworkState extends State<TeacherHomework> {
  Future<HomeworkList>? homeworks;

  String? _token;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        Utils.getStringValue('id').then((value) {
          setState(() {
            homeworks = fetchHomework(int.parse(value ?? ''));
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homeworks'),
      backgroundColor: Colors.white,
      body: FutureBuilder<HomeworkList>(
        future: homeworks,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot != null) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: snapshot.data?.homeworks.length ?? 0,
              itemBuilder: (context, index) {
                return TeacherHomeworkRow(snapshot.data?.homeworks[index] ?? Homework());
              },
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<HomeworkList> fetchHomework(int id) async {
    final response = await http.get(Uri.parse(InfixApi.getHomeWorkListUrl(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return HomeworkList.fromJson(jsonData['data']['homeworkLists']);
    } else {
      throw Exception('failed to load');
    }
  }
}
