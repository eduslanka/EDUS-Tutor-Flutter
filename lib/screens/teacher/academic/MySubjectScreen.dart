// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/TeacherSubject.dart';
import 'package:edus_tutor/utils/widget/ShimmerListWidget.dart';
import 'package:edus_tutor/utils/widget/TeacherSubjectRow.dart';

class MySubjectScreen extends StatefulWidget {
  const MySubjectScreen({super.key});

  @override
  _MySubjectScreenState createState() => _MySubjectScreenState();
}

class _MySubjectScreenState extends State<MySubjectScreen> {
  Future<TeacherSubjectList>? subjects;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('token').then(
      (value) {
        setState(() {
          _token = value ?? '';
        });
        Utils.getStringValue('id').then((value) {
          setState(() {
            subjects = getAllSubject(int.parse(value ?? ''));
          });
        });
      },
    );
  }

  @override
  void initState() {
    Utils.getStringValue('token').then(
      (value) {
        setState(() {
          _token = value ?? '';
        });
        Utils.getStringValue('id').then((value) {
          setState(() {
            subjects = getAllSubject(int.parse(value ?? ''));
          });
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Subjects'),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.all(15.0),
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
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text('Code'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  Expanded(
                    child: Text('Type'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            FutureBuilder<TeacherSubjectList>(
              future: subjects,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.subjects.length ?? 0,
                    itemBuilder: (context, index) {
                      return TeacherSubjectRowLayout(
                          snapshot.data?.subjects[index] ?? TeacherSubject());
                    },
                  );
                } else {
                  print('3::::::::::${snapshot.data?.subjects.length}');
                  return const ShimmerList(
                    height: 20,
                    itemCount: 3,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<TeacherSubjectList> getAllSubject(int id) async {
    print('This is calling');

    try {
      final response = await http.get(Uri.parse(EdusApi.getTeacherSubject(id)),
          headers: Utils.setHeader(_token.toString()));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(jsonData['data']['subjectsName']);
        return TeacherSubjectList.fromJson(jsonData['data']['subjectsName']);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e, t) {
      print(e);
      print(t);
    }
    return TeacherSubjectList.fromJson([]);
  }
}
