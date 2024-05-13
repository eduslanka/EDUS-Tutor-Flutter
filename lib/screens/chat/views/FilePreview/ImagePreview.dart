import 'package:flutter/material.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewPage extends StatefulWidget {
  final String? imageUrl;
  final String? title;
  const ImagePreviewPage({Key? key, this.imageUrl, this.title}) : super(key: key);

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: "",
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.imageUrl ?? ''),
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}
