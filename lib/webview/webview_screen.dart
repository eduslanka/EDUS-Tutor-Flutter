// // Flutter imports:
// import 'package:flutter/material.dart';

// // Package imports:
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;

//   const WebViewScreen(this.url, {Key? key}) : super(key: key);

//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (await _controller.canGoBack()) {
//           _controller.goBack();
//           return false;
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Zoom"),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () async {
//               if (await _controller.canGoBack()) {
//                 _controller.goBack();
//               } else {
//                 Navigator.of(context).pop();
//               }
//             },
//           ),
//         ),
//         body: WebView(
//           initialUrl: widget.url,
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController) {
//             _controller = webViewController;
//           },
//         ),
//       ),
//     );
//   }
// }
