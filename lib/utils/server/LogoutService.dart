// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:

import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';

class LogoutService {
  logoutDialog() {
    String? token;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: Get.textTheme.headlineSmall?.copyWith(
          fontSize: 12.sp,
          color: Colors.red,
        ),
      ),
      onPressed: () {
        Get.back(closeOverlays: true);
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: Get.textTheme.headlineSmall?.copyWith(
          fontSize: ScreenUtil().setSp(12),
          color: Colors.green,
        ),
      ),
      onPressed: () async {
        // await Utils.getStringValue('token').then((value) {
        //   _token = value ?? '';
        // });
        Utils.clearAllValue();

        Get.offNamedUntil("/", ModalRoute.withName('/'));

        var response = await http.post(Uri.parse(EdusApi.logout()),
            headers: Utils.setHeader(token.toString()));
        if (response.statusCode == 200) {
        } else {
          //  Utils.showToast('Unable to logout');
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text(
        "Logout",
        style: TextStyle(color: Utils.baseBlue),
      ),
      content: const Text("Would you like to logout?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    return alert;
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
}
