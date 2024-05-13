// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final url;

  const WebViewScreen(this.url, {Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  final _webViewPlugin = FlutterWebviewPlugin();
  
  @override
  void initState() {
    super.initState();
    _webViewPlugin.onDestroy.listen((_) {
      if (Navigator.canPop(context)) {
        // exiting the screen
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: WebviewScaffold(
          hidden: true,
          url: '${widget.url}',
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
          appCacheEnabled: true,
          appBar: AppBar(
            title: const Text("Zoom"),
          ),
        ),
        onWillPop: () {
          return _webViewPlugin.close().then((_) => true);
          // return _webViewPlugin.close();
        }
    );
  }
}
