// Flutter imports:

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/controller/user_controller.dart';
import 'package:edus_tutor/screens/fees/controller/student_fees_controller.dart';
import 'package:edus_tutor/utils/StudentRecordWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/screens/fees/model/FeesRecord.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:edus_tutor/utils/server/LogoutService.dart';
import 'package:edus_tutor/screens/fees/fees_student/fees_student_new/fees_new_row_layout.dart';

class StudentFeesNew extends StatefulWidget {
  final String? id;

  const StudentFeesNew({Key? key, this.id}) : super(key: key);
  @override
  _StudentFeesNewState createState() => _StudentFeesNewState();
}

class _StudentFeesNewState extends State<StudentFeesNew> {
  final StudentFeesController _studentFeesController =
      Get.put(StudentFeesController());

  final UserController _userController = Get.put(UserController());

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records?.first ?? Record();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConfig.appToolbarBackground),
                fit: BoxFit.cover,
              ),
              color: Color(0xff053EFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 25.w,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Fees".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(LogoutService().logoutDialog());
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_studentFeesController.isFeesLoading.value) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StudentRecordWidget(
                  onTap: (Record record) async {
                    _studentFeesController.userController.selectedRecord.value =
                        record;
                    await _studentFeesController.fetchFeesRecord(
                      _studentFeesController.userController.studentId.value,
                      record.id ?? 0,
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Obx(() {
                    if (_studentFeesController.isFeesLoading.value) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      if (_studentFeesController
                              .feesRecordList.value.feesRecords!.isEmpty) {
                        return Utils.noDataWidget();
                      } else {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: _studentFeesController
                              .feesRecordList.value.feesRecords?.length ?? 0,
                          itemBuilder: (context, index) {
                            FeesRecord? feesRecord = _studentFeesController
                                .feesRecordList.value.feesRecords?[index];

                            return FeesRowNew(
                              feesRecord ?? FeesRecord(),
                              widget.id ?? '',
                            );
                          },
                        );
                      }
                    }
                  }),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
