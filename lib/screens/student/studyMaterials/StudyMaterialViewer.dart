// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:edus_tutor/utils/pdf_flutter.dart';

class DownloadViewer extends StatefulWidget {
  final String? title;
  final String? filePath;
  const DownloadViewer({Key? key, this.title, this.filePath}) : super(key: key);
  @override
  _DownloadViewerState createState() => _DownloadViewerState();
}

class _DownloadViewerState extends State<DownloadViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(title: widget.title ?? ''), body: Container()
        // WebView(
        //   initialUrl: widget.filePath ?? '',
        //   javascriptMode: JavascriptMode.unrestricted,
        // ),
        );
  }
}
