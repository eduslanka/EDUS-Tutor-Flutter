// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:infixedu/screens/student/homework/UploadHomework.dart';
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentHomework.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class StudentHomeworkRow extends StatefulWidget {
  Homework homework;
  String type;

  StudentHomeworkRow(this.homework, this.type, {Key? key}) : super(key: key);

  @override
  _StudentHomeworkRowState createState() => _StudentHomeworkRowState();
}

class _StudentHomeworkRowState extends State<StudentHomeworkRow> {
  int? rule;
  var progress = "Download";

  // ignore: prefer_typing_uninitialized_variables
  var received;

  Random random = Random();

  final GlobalKey _globalKey = GlobalKey();
  String? _id;

  @override
  void initState() {
    Utils.getStringValue('id').then((value) {
      _id = value;
    });

    Utils.getStringValue('rule').then((value) {
      rule = int.parse(value ?? '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
      child: InkWell(
        onTap: () {
          showAlertDialog(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.homework.subjectName ?? '',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Text(
                    'View'.tr,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.deepPurpleAccent,
                        decoration: TextDecoration.underline),
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
                          'Created'.tr,
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
                          widget.homework.homeworkDate ?? 'N/A',
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
                          'Submission'.tr,
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
                          widget.homework.submissionDate ?? 'N/A',
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
                          'Evaluation'.tr,
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
                          widget.homework.evaluationDate ?? 'N/A',
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
                          'Status'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        getStatus(context, widget.homework.status ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            widget.homework.obtainedMarks == ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Marks'.tr,
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
                        widget.homework.marks == null ||  widget.homework.marks == '0'
                            ? 'N/A'
                            : widget.homework.marks.toString(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Obtained Marks',
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
                        widget.homework.obtainedMarks == null
                            ? 'N/A'
                            : widget.homework.obtainedMarks.toString(),
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
            Container(
              height: 0.5,
              margin: const EdgeInsets.only(top: 10.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.purple, Colors.deepPurple]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.homework.subjectName ?? '',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          widget.homework.obtainedMarks == ""
                              ? Text(
                                  "Marks: ".tr + '${widget.homework.marks}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  maxLines: 1,
                                )
                              : Text(
                                  "Obtained Marks: " +
                                      '${widget.homework.obtainedMarks}',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  maxLines: 1,
                                )
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
                                    'Created'.tr,
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
                                    widget.homework.homeworkDate ?? '',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Submission'.tr,
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
                                    widget.homework.submissionDate ?? '',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Evaluation'.tr,
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
                                    widget.homework.evaluationDate ?? 'N/A',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            widget.type == 'student'
                                ? Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Status'.tr,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        getStatus(
                                            context, widget.homework.status ?? ''),
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                widget.homework.description ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.homework.fileUrl == null ||
                                    widget.homework.fileUrl == ''
                                ? Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: ScreenUtil().setWidth(145),
                                      height: ScreenUtil().setHeight(40),
                                    ),
                                  )
                                : InkWell(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: Utils.gradientBtnDecoration,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Expanded(
                                            child: Icon(
                                              Icons.cloud_download,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Download".tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      PermissionCheck()
                                          .checkPermissions(context);
                                      showDownloadAlertDialog(
                                          context, widget.homework.subjectName ?? '');
                                    },
                                  ),
                            widget.type == 'student' && rule != 3
                                ? widget.homework.status == "incompleted"
                                    ? InkWell(
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration:
                                              Utils.gradientBtnDecoration,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Expanded(
                                                child: Icon(
                                                  Icons.cloud_download,
                                                  size: 24,
                                                ),
                                              ),
                                              Text(
                                                "Upload".tr,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDialog<void>(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return UploadHomework(
                                                homework: widget.homework,
                                                userID: _id,
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : Container()
                                : Container()
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == 'incompleted') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Incomplete',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (status == 'Completed') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Completed',
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
      return Container();
    }
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
        widget.homework.fileUrl != null
            ? downloadFile(widget.homework.fileUrl ?? '', context, title)
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
      FileUtils.mkdir([dirloc]);
      Utils.showToast("Downloading...");

      await dio.download(
          InfixApi.root + url, dirloc + AppFunction.getExtention(url),
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (receivedBytes, totalBytes) async {
        received = ((receivedBytes / totalBytes) * 100);
        setState(() {
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        });
        if (received == 100.0) {
          if (url.contains('.pdf')) {
            Utils.showToast(
                "Download Completed. File is also available in your download folder.");
            Navigator.push(
                context,
                ScaleRoute(
                    page: DownloadViewer(
                        title: title, filePath: InfixApi.root + url)));
          } else {
            var file =
                await DefaultCacheManager().getSingleFile(InfixApi.root + url);
            OpenFilex.open(file.path);

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
}
