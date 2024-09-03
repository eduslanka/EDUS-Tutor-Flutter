// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:extended_image/extended_image.dart';

// Project imports:
import 'package:edus_tutor/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:edus_tutor/utils/pdf_flutter.dart';

class UploadedFilesView extends StatefulWidget {
  const UploadedFilesView({Key? key, this.files, this.fileName})
      : super(key: key);

  final List<String>? files;
  final String? fileName;

  @override
  _UploadedFilesViewState createState() => _UploadedFilesViewState();
}

class _UploadedFilesViewState extends State<UploadedFilesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.fileName ?? '',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
            itemCount: widget.files?.length ?? 0,
            separatorBuilder: (context, index) {
              return const BottomLine();
            },
            itemBuilder: (context, index) {
              return widget.files![index].contains('.pdf')
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DownloadViewer(
                                  title: 'PDF',
                                  filePath:
                                      EdusApi.root + '${widget.files?[index]}',
                                )));
                      },
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          // WebView(
                          //   initialUrl:
                          //       EdusApi.root + '${widget.files?[index]}',
                          //   javascriptMode: JavascriptMode.unrestricted,
                          // ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf,
                                  color: Color(0xff053EFF),
                                ),
                                Text(
                                  'View',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ExtendedImage.network(
                      EdusApi.root + '${widget.files?[index]}',
                      fit: BoxFit.cover,
                      cache: true,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: true,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                      //cancelToken: cancellationToken,
                    );
            }),
      ),
    );
  }
}
