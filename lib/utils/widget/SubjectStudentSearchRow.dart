// Flutter imports:
import 'package:flutter/material.dart';
import 'package:edus_tutor/config/app_config.dart';

// Project imports:
import 'package:edus_tutor/screens/student/Profile.dart';
import 'package:edus_tutor/screens/student/SubjectStudentAttendance.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/Student.dart';
import 'ScaleRoute.dart';

// ignore: must_be_immutable
class SubjectStudentRow extends StatefulWidget {
  Student student;
  String? status;
  String? token;
  int? subjectCode;
  String? subjectName;

  SubjectStudentRow(this.student,
      {super.key, this.status, this.token, this.subjectCode, this.subjectName});

  @override
  // ignore: no_logic_in_create_state
  _SubjectStudentRowState createState() => _SubjectStudentRowState(
        student,
        status: status ?? '',
        token: token ?? '',
        subjectCode: subjectCode ?? 0,
        subjectName: subjectName ?? '',
      );
}

class _SubjectStudentRowState extends State<SubjectStudentRow> {
  Student student;
  String? status;
  String? token;
  int? subjectCode;
  String? subjectName;

  _SubjectStudentRowState(this.student,
      {this.status, this.token, this.subjectCode, this.subjectName});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String image = student.photo == null || student.photo == ''
        ? '${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg'
        : '${EdusApi.root}${student.photo}';
    return InkWell(
      onTap: () {
        if (status == 'attendance') {
          Navigator.push(
              context,
              ScaleRoute(
                  page: SubjectStudentAttendanceScreen(
                id: student.uid,
                token: token,
                subjectCode: subjectCode,
                subjectName: subjectName,
              )));
        } else {
          Navigator.push(
              context,
              ScaleRoute(
                  page: Profile(
                id: student.uid.toString(),
                image: image,
              )));
        }
      },
      splashColor: const Color(0xff053EFF),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.grey,
            ),
            title: Text(
              student.name ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(student.classSection ?? '',
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xff053EFF), Color(0xff053EFF)]),
            ),
          )
        ],
      ),
    );
  }
}
