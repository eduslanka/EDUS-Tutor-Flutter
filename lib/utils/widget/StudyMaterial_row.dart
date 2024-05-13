// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:infixedu/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:infixedu/utils/FunctinsData.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/UploadedContent.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:url_launcher/url_launcher.dart';
import '../permission_check.dart';

// ignore: must_be_immutable
class StudyMaterialListRow extends StatelessWidget {
  UploadedContent uploadedContent;
  var progress = "";
  // ignore: prefer_typing_uninitialized_variables
  var received;

  StudyMaterialListRow(this.uploadedContent, {Key? key}) : super(key: key);

  Random random = Random();

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _globalKey,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${uploadedContent.contentTitle}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              uploadedContent.uploadFile == null ||
                      uploadedContent.uploadFile == ''
                  ? Container()
                  : InkWell(
                    onTap: (() {
                      PermissionCheck().checkPermissions(context);
                      showDownloadAlertDialog(
                          context, uploadedContent.contentTitle ?? '');
                    }),
                    child: Text(
                      'Download',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 15,
                          color: Colors.deepPurpleAccent,
                          decoration: TextDecoration.underline),
                    ),
                  ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Added  ${uploadedContent.uploadDate.toString() ?? 'N/A'}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    uploadedContent.description.toString() == null ||
                            uploadedContent.description.toString() == "null"
                        ? const SizedBox.shrink()
                        : Text(
                            uploadedContent.description.toString(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                    uploadedContent.sourceUrl == null
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              Text(
                                "Source Url:",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  // ignore: deprecated_member_use
                                  if (!await launch(uploadedContent.sourceUrl ?? '')) {
                                    throw 'Could not launch ${uploadedContent.sourceUrl}';
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: Utils.gradientBtnDecoration,
                                  child: Text(
                                    "Click here",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.purple, Colors.deepPurple]),
            ),
          ),
        ],
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        uploadedContent.contentTitle ?? '',
                        style: Theme.of(context).textTheme.headlineSmall,
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
                                    'Created',
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    uploadedContent.uploadDate.toString(),
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              uploadedContent.description ?? '',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  showDownloadAlertDialog(BuildContext context, String title) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: Text("Download", style: Theme.of(context).textTheme.headlineMedium),
      onPressed: () {
        uploadedContent.uploadFile != null
            ? downloadFile(uploadedContent.uploadFile ?? '', context, title)
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
        progress =
            ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        print("progress::::::::::::::: $received");

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

            // await canLaunch(InfixApi.root + url)
            //     ? await launch(InfixApi.root + url)
            //     : throw 'Could not launch ${InfixApi.root + url}';
          }
        }
      });
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    }
    progress = "Download Completed.Go to the download folder to find the file";
  }
}
