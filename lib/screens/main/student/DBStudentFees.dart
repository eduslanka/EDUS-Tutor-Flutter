import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:edus_tutor/screens/fees/fees_student/StudentFeesNew.dart';

class DBStudentFees extends StatefulWidget {
  const DBStudentFees({
    super.key,
  });

  @override
  _DBStudentFeesState createState() => _DBStudentFeesState();
}

class _DBStudentFeesState extends State<DBStudentFees> {
  @override
  Widget build(BuildContext context) {
    return const StudentFeesNew();
  }
}
