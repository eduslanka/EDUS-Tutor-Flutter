

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:edus_tutor/controller/system_controller.dart';
import 'package:edus_tutor/screens/fees/fees_student/StudentFeesNew.dart';
import 'package:edus_tutor/screens/fees/fees_student/StudentFeesOld.dart';

class DBStudentFees extends StatefulWidget {
  final String? id;

  const DBStudentFees({Key? key, this.id}) : super(key: key);

  @override
  _DBStudentFeesState createState() => _DBStudentFeesState();
}

class _DBStudentFeesState extends State<DBStudentFees> {
  final SystemController systemController = Get.put(SystemController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (systemController.systemSettings.value.data?.feesStatus == 0) {
        return StudentFeesOld(
          id: widget.id,
        );
      } else {
        return StudentFeesNew(
          id: widget.id,
        );
      }
    });
  }
}




