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
import 'package:edus_tutor/utils/model/Dormitory.dart';
import 'package:edus_tutor/utils/widget/Dormitory_row.dart';

class DormitoryScreen extends StatefulWidget {
  const DormitoryScreen({super.key});

  @override
  _DormitoryScreenState createState() => _DormitoryScreenState();
}

class _DormitoryScreenState extends State<DormitoryScreen> {
  Future<DormitoryList>? dormitories;

  String _token = '';

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
    }).then((value) {
      dormitories = getAllDormitory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Dormitory'),
      backgroundColor: Colors.white,
      body: FutureBuilder<DormitoryList>(
        future: dormitories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.dormitories.isNotEmpty) {
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemCount: snapshot.data?.dormitories.length ?? 0,
                itemBuilder: (context, index) {
                  return DormitoryRow(snapshot.data!.dormitories[index]);
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
        },
      ),
    );
  }

  Future<DormitoryList> getAllDormitory() async {
    final response = await http.get(Uri.parse(EdusApi.studentDormitoryList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return DormitoryList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
