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
import 'package:edus_tutor/utils/model/Student.dart';
import 'package:edus_tutor/utils/widget/StudentSearchRow.dart';

// ignore: must_be_immutable
class StudentSearchNameRoll extends StatefulWidget {
  String? name;
  String? roll;
  String? url;
  String? token;

  StudentSearchNameRoll(
      {super.key, this.name, this.roll, this.url, this.token});

  @override
  // ignore: no_logic_in_create_state
  _StudentSearchNameRollState createState() => _StudentSearchNameRollState(
      name: name ?? '', roll: roll ?? '', url: url ?? '', token: token ?? '');
}

class _StudentSearchNameRollState extends State<StudentSearchNameRoll> {
  String? name;
  String? roll;
  String? url;
  Future<StudentList>? student;
  String? token;

  _StudentSearchNameRollState({this.name, this.roll, this.url, this.token});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      student = getSearchStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Student List'),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<StudentList>(
        future: student,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.students.length ?? 0,
              itemBuilder: (context, index) {
                return StudentRow(snapshot.data?.students[index] ?? Student());
              },
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Future<StudentList> getSearchStudent() async {
    final response = await http.get(Uri.parse(url ?? ''),
        headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentList.fromJson(jsonData['data']['students']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
