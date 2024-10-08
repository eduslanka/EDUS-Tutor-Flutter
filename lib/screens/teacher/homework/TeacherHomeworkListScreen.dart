// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentHomework.dart';
import 'package:edus_tutor/utils/widget/TeacherHomeworkRow.dart';

class TeacherHomework extends StatefulWidget {
  const TeacherHomework({super.key});

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
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: snapshot.data?.homeworks.length ?? 0,
              itemBuilder: (context, index) {
                return TeacherHomeworkRow(
                    snapshot.data?.homeworks[index] ?? Homework());
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
    try {
      final response = await http.get(Uri.parse(EdusApi.getHomeWorkListUrl(id)),
          headers: Utils.setHeader(_token.toString()));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        return HomeworkList.fromJson(jsonData['data']['homeworkLists']);
      } else {
        throw Exception('failed to load');
      }
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
      rethrow;
    }
  }
}
