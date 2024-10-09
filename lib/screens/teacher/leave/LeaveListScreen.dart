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
import 'package:edus_tutor/utils/model/Leave.dart';
import 'package:edus_tutor/utils/widget/Leave_row.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({super.key});

  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  Future<LeaveList>? leaves;
  String? _token;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          leaves = fetchLeave(int.parse(value ?? ''));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Leave List'),
      backgroundColor: Colors.white,
      body: FutureBuilder<LeaveList>(
        future: leaves,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.leaves.length ?? 0,
              itemBuilder: (context, index) {
                return LeaveRow(snapshot.data?.leaves[index] ?? Leave());
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

  Future<LeaveList> fetchLeave(int id) async {
    final response = await http.get(Uri.parse(EdusApi.getLeaveList(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return LeaveList.fromJson(jsonData['data']['leave_list']);
    } else {
      throw Exception('failed to load');
    }
  }
}
