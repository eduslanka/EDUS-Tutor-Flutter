// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:edus_tutor/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/Content.dart';
import 'package:edus_tutor/utils/permission_check.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';

// ignore: must_be_immutable
class ContentRow extends StatefulWidget {
  Content content;
  Animation animation;
  final VoidCallback? onPressed;
  String? token;
  dynamic index;

  ContentRow(this.content, this.animation,
      {super.key, this.onPressed, this.token, this.index});

  @override
  // ignore: no_logic_in_create_state
  _ContentRowState createState() => _ContentRowState(token);
}

class _ContentRowState extends State<ContentRow> {
  var progress = "Download";
  // ignore: prefer_typing_uninitialized_variables
  var received;
  // ignore: prefer_typing_uninitialized_variables
  final _token;

  _ContentRowState(this._token);

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      // sizeFactor: widget.animation,
      sizeFactor: widget.animation as Animation<double>,

      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
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
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      widget.content.contentTitle ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        widget.content.description ?? "N/A",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontSize:
                                                    ScreenUtil().setSp(12)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.content.contentTitle ?? 'NA',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: ScreenUtil().setSp(12)),
                      maxLines: 1,
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        PermissionCheck().checkPermissions(context);
                        showDownloadAlertDialog(
                            context, widget.content.contentTitle);
                      },
                      child: widget.content.uploadFile!.isNotEmpty
                          ? Icon(
                              FontAwesomeIcons.download,
                              size: ScreenUtil().setSp(15),
                              color: Colors.blueAccent,
                            )
                          : Container()),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDeleteAlertDialog(context);
                    },
                    child: Icon(
                      FontAwesomeIcons.trash,
                      size: ScreenUtil().setSp(15),
                      color: Colors.redAccent,
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
                            'Type',
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
                            widget.content.contentType ?? "N/A",
                            // : AppFunction.getContentType(content.type),
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
                            'Date',
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
                            widget.content.uploadDate ?? 'N/A',
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
                            'Available for',
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
                            widget.content.availableFor ?? '',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
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
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget yesButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {
          deleteContent(widget.content.id);
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: const Text("Would you like to delete the file?"),
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

  showDownloadAlertDialog(BuildContext context, title) {
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
        widget.content.uploadFile != null
            ? downloadFile(widget.content.uploadFile ?? '', context, title)
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

  Future<void> deleteContent(dynamic cid) async {
    final response = await http.get(Uri.parse(EdusApi.deleteContent(cid)),
        headers: Utils.setHeader(_token));

    if (response.statusCode == 200) {
      widget.onPressed!();
      Utils.showToast('Content deleted');
    } else {
      throw Exception('failed to load');
    }
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
//FileUtils.mkdir([dirloc]);
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
            print('File ::::::::: $file');

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

  getContentType(String contentType) {
    if (contentType == "as") {
      return "Assignment";
    } else if (contentType == "st") {
      return "Study Material";
    } else if (contentType == "sy") {
      return "Syllabus";
    } else if (contentType == "ot") {
      return "Other Download";
    }
  }
}
