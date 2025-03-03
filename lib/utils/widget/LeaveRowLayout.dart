// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
//import 'package:file_utils/file_utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:edus_tutor/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/exception/DioException.dart';
import 'package:edus_tutor/utils/model/LeaveAdmin.dart';
import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';
import '../permission_check.dart';

// ignore: must_be_immutable
class LeaveRowLayout extends StatefulWidget {
  LeaveAdmin leave;

  LeaveRowLayout(this.leave, {super.key});

  @override
  _LeaveRowLayoutState createState() => _LeaveRowLayoutState();
}

class _LeaveRowLayoutState extends State<LeaveRowLayout> {
  Response? response;

  Dio dio = Dio();

  // final _globalKey = GlobalKey();

  String radioStr = 'Pending';

  String? _token;
  var progress = "Download";

  // ignore: prefer_typing_uninitialized_variables
  var received;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.leave.type ?? '',
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: 80.0,
                child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'View',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Apply Date',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.leave.applyDate ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'To',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.leave.leaveTo ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'From',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        widget.leave.leaveFrom ?? '',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Status',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      getStatus(context),
                    ],
                  ),
                ),
              ],
            ),
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
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Material(
                          child: ListView(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Reason: ' '${widget.leave.reason}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      'Applied by: ' '${widget.leave.fullName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                              const BottomLine(),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Leave Type',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            widget.leave.type ?? '',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Leave From',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            widget.leave.leaveFrom ?? '',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Leave To',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            widget.leave.leaveTo ?? '',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Apply Date',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            widget.leave.applyDate ?? '',
                                            maxLines: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              widget.leave.file == null ||
                                      widget.leave.file == ''
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          PermissionCheck()
                                              .checkPermissions(context);
                                          showDownloadAlertDialog(context,
                                              widget.leave.reason ?? '');
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'Attached File: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                      fontSize: ScreenUtil()
                                                          .setSp(16)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Download',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontSize: ScreenUtil()
                                                          .setSp(16)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              const BottomLine(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Leave Status',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: ScreenUtil().setSp(14)),
                                  maxLines: 1,
                                ),
                              ),
                              RadioListTile(
                                groupValue: radioStr,
                                title: Text("Pending",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: ScreenUtil().setSp(14))),
                                value: 'Pending',
                                onChanged: (val) {
                                  setState(() {
                                    radioStr = '$val';
                                  });
                                },
                                activeColor: const Color(0xff053EFF),
                                selected: true,
                                dense: true,
                              ),
                              RadioListTile(
                                groupValue: radioStr,
                                title: Text("Approve",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: ScreenUtil().setSp(14))),
                                value: 'Approve',
                                onChanged: (val) {
                                  setState(() {
                                    radioStr = '$val';
                                  });
                                },
                                activeColor: const Color(0xff053EFF),
                                selected: true,
                                dense: true,
                              ),
                              RadioListTile(
                                groupValue: radioStr,
                                title: Text("Cancel",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: ScreenUtil().setSp(14))),
                                value: 'Cancel',
                                onChanged: (val) {
                                  setState(() {
                                    radioStr = '$val';
                                  });
                                },
                                activeColor: const Color(0xff053EFF),
                                selected: true,
                                dense: true,
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: const Color(0xff053EFF),
                                    ),
                                    child: Text(
                                      "Save",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(14)),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Utils.showToast(radioStr);
                                  addUpdateData(widget.leave.id,
                                          radioStr.substring(0, 1))
                                      .then((value) {
                                    if (value) {
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  showDownloadAlertDialog(BuildContext context, String title) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: const Text("Download"),
      onPressed: () {
        widget.leave.file != null
            ? downloadFile(widget.leave.file ?? '', context, title)
            : Utils.showToast('no file found');
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Download",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: const Text("Would you like to download the file?"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> downloadFile(
      String url, BuildContext context, String title) async {
    Dio dio = Dio();

    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationSupportDirectory()).path;
    }
    Utils.showToast(dirloc);

    try {
      // FileUtils.mkdir([dirloc]);
      Utils.showToast("Downloading...");

      await dio.download(
          EdusApi.root + url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        setState(() {
          progress =
              "${((receivedBytes / totalBytes) * 100).toStringAsFixed(0)}%";
        });
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            Utils.showToast(
                "Download Completed. File is also available in your download folder.");
            Navigator.push(
                context,
                ScaleRoute(
                    page: DownloadViewer(
                        title: title, filePath: EdusApi.root + url)));
          } else {
            var file =
                await DefaultCacheManager().getSingleFile(EdusApi.root + url);
            OpenFile.open(file.path);

            Utils.showToast(
                "Download Completed. File is also available in your download folder.");
          }
        }
      });
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    // progress = "Download Completed.Go to the download folder to find the file";
  }

  Future<bool> addUpdateData(dynamic id, String status) async {
    response = await dio
        .get(
      EdusApi.setLeaveStatus(id, status),
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showToast(errorMessage);
    });
    if (response?.statusCode == 200) {
      Utils.showToast('Leave Updated');
      return true;
    } else {
      return false;
    }
  }

  Widget getStatus(BuildContext context) {
    if (widget.leave.status == 'P') {
      radioStr = 'Pending';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.amber),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Pending',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (widget.leave.status == 'A') {
      radioStr = 'Approve';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green.shade500),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Approved',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      radioStr = 'Cancel';
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Cancelled',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }
}
