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
import 'package:edus_tutor/utils/model/Notice.dart';
import 'package:edus_tutor/utils/widget/NoticeRow.dart';

class StaffNoticeScreen extends StatefulWidget {
  const StaffNoticeScreen({super.key});

  @override
  _StaffNoticeScreenState createState() => _StaffNoticeScreenState();
}

class _StaffNoticeScreenState extends State<StaffNoticeScreen> {
  Future<NoticeList>? notices;

  String? status;
  String? _token;
  String? _schoolId;
  @override
  void initState() {
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
        notices = getNotices(int.parse(value ?? ''));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Staff Notice'),
      backgroundColor: Colors.white,
      body: FutureBuilder<NoticeList>(
        future: notices,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.notices.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: snapshot.data?.notices.length ?? 0,
                  itemBuilder: (context, index) {
                    return NoticRowLayout(
                        snapshot.data?.notices[index] ?? Notice());
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Divider(
                        color: Color(0xff053EFF),
                        thickness: 0.5,
                      ),
                    );
                  },
                ),
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

  Future<NoticeList> getNotices(dynamic id) async {
    await Utils.getStringValue('schoolId').then((value) {
      _schoolId = value;
    });
    final response = await http.get(Uri.parse(EdusApi.notice(_schoolId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return NoticeList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
