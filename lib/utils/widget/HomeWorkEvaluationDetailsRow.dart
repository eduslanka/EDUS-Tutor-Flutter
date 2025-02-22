// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
//import 'package:file_utils/file_utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:edus_tutor/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/HomeworkEvaluation.dart';
import 'package:edus_tutor/utils/permission_check.dart';
import '../FunctinsData.dart';
import '../Utils.dart';
import 'ScaleRoute.dart';

class HomeWorkEvaluationDetailsRow extends StatefulWidget {
  const HomeWorkEvaluationDetailsRow(this.studentHomeworkEvaluation,
      {super.key});

  final StudentHomeworkEvaluation studentHomeworkEvaluation;

  @override
  _HomeWorkEvaluationDetailsRowState createState() =>
      _HomeWorkEvaluationDetailsRowState();
}

class _HomeWorkEvaluationDetailsRowState
    extends State<HomeWorkEvaluationDetailsRow> {
  var progress = "Download";
  // ignore: prefer_typing_uninitialized_variables
  var received;

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl) {
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
        fileUrl != null
            ? downloadFile(fileUrl, context, title)
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.studentHomeworkEvaluation.subjectName ?? '',
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(14)),
              ),
              InkWell(
                onTap: () {
                  PermissionCheck().checkPermissions(context);
                  showDownloadAlertDialog(
                      context,
                      widget.studentHomeworkEvaluation.subjectName ?? '',
                      widget.studentHomeworkEvaluation.file ?? '');
                },
                child: const Icon(
                  FontAwesomeIcons.download,
                  size: 15,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Created',
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
                      widget.studentHomeworkEvaluation.homeworkDate ??
                          'not assigned',
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
                      'Submission',
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
                      widget.studentHomeworkEvaluation.submissionDate ??
                          'not assigned',
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
                      'Evaluation',
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
                      widget.studentHomeworkEvaluation.evaluationDate ?? 'N/A',
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
                      'Marks',
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
                      widget.studentHomeworkEvaluation.marks == null
                          ? 'not assigned'
                          : widget.studentHomeworkEvaluation.marks.toString(),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
