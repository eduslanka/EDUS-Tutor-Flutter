// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/screens/student/studyMaterials/StudyMaterialViewer.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/custom_widgets/CustomRadioButton/CustomButton/ButtonTextStyle.dart';
import 'package:edus_tutor/utils/custom_widgets/CustomRadioButton/custom_radio_button.dart';
import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EvaluateScreen extends StatefulWidget {
  final String? studentName;
  final String? marks;
  final String? teacherComment;
  final String? status;
  final dynamic studentId;
  final dynamic homeworkId;
  final List<String>? files;
  final String? totalMarks;

  const EvaluateScreen(
      {super.key,
      this.studentName,
      this.marks,
      this.teacherComment,
      this.status,
      this.studentId,
      this.homeworkId,
      this.files,
      this.totalMarks});

  @override
  _EvaluateScreenState createState() => _EvaluateScreenState();
}

class _EvaluateScreenState extends State<EvaluateScreen> {
  TextEditingController marksController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selectedComment = '';
  String selectedStatus = '';

  String evaluationDate = '';
  bool isResponse = false;

  Response? response;
  Dio dio = Dio();

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  var id;
  var _token;

  @override
  void initState() {
    marksController.text = widget.marks ?? '';
    selectedComment = widget.teacherComment ?? '';
    selectedStatus = widget.status ?? '';
    evaluationDate =
        "${DateTime.now().year}-${getAbsoluteDate(DateTime.now().month)}-${getAbsoluteDate(DateTime.now().day)}";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        Utils.getStringValue('id').then((idValue) {
          setState(() {
            id = idValue;
          });
        });
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.studentName ?? '',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Column(
              children: [
                TextFormField(
                  controller: marksController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  style: Theme.of(context).textTheme.titleLarge,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? value) {
                    RegExp regExp = RegExp(r'^[0-9]*$');
                    if (value!.isEmpty) {
                      return 'Please enter a valid mark';
                    }
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter a number';
                    }
                    if ((int.tryParse(value) ?? 0) >
                        (int.tryParse(widget.totalMarks ?? '') ?? 0)) {
                      return 'Marks must not greater than total marks';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Set Marks out of ${widget.totalMarks}",
                    labelText: "Set Marks out of ${widget.totalMarks}",
                    labelStyle: Theme.of(context).textTheme.headlineMedium,
                    errorStyle:
                        const TextStyle(color: Colors.blue, fontSize: 15.0),
                    errorMaxLines: 3,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text('Comment',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRadioButton(
                          defaultSelected: widget.teacherComment,
                          elevation: 0,
                          unSelectedColor: Theme.of(context).canvasColor,
                          buttonLables: const [
                            'Good',
                            'Not Good',
                          ],
                          buttonValues: const [
                            "G",
                            "NG",
                          ],
                          buttonTextStyle: ButtonTextStyle(
                              selectedColor: Colors.white,
                              unSelectedColor: const Color(0xff415094),
                              textStyle:
                                  TextStyle(fontSize: ScreenUtil().setSp(14))),
                          radioButtonValue: (value) {
                            setState(() {
                              selectedComment = value;
                            });
                          },
                          selectedColor:
                              Theme.of(context).colorScheme.secondary,
                          enableShape: true,
                          customShape: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          horizontal: false,
                          enableButtonWrap: true,
                          wrapAlignment: WrapAlignment.start,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text('Homework Status',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomRadioButton(
                            defaultSelected: widget.status,
                            elevation: 0,
                            absoluteZeroSpacing: false,
                            unSelectedColor: Theme.of(context).canvasColor,
                            buttonLables: const [
                              'Completed',
                              'Not Completed',
                            ],
                            buttonValues: const [
                              "C",
                              "NC",
                            ],
                            buttonTextStyle: ButtonTextStyle(
                                selectedColor: Colors.white,
                                unSelectedColor: const Color(0xff415094),
                                textStyle: TextStyle(
                                    fontSize: ScreenUtil().setSp(14))),
                            radioButtonValue: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            selectedColor:
                                Theme.of(context).colorScheme.secondary,
                            enableShape: true,
                            customShape: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            horizontal: false,
                            enableButtonWrap: false,
                            wrapAlignment: WrapAlignment.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  child: GestureDetector(
                    onTap: evaluateSubmit,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: ScreenUtil().setHeight(30),
                      decoration: Utils.gradientBtnDecoration,
                      child: Text(
                        "Evaluate",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isResponse == true
                      ? const LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                        )
                      : const Text(''),
                ),
                ListView.separated(
                    shrinkWrap: true,
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
                                              '${EdusApi.root}${widget.files?[index]}',
                                        )));
                              },
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  // WebView(
                                  //   initialUrl: EdusApi.root +
                                  //       '${widget.files?[index]}',
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
                              '${EdusApi.root}${widget.files?[index]}',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void evaluateSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isResponse = true;
      });
      final response = await http.post(
        Uri.parse(EdusApi.evaluateHomework),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": _token.toString(),
        },
        body: jsonEncode(<String, dynamic>{
          "homework_id": widget.homeworkId.toString(),
          "student_id": [widget.studentId.toString()],
          "marks": [marksController.text],
          "teacher_comments": {
            "${widget.studentId}": selectedComment,
          },
          "homework_status": {
            "${widget.studentId}": selectedStatus,
          },
          "login_id": id,
          "evaluation_date": evaluationDate,
        }),
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'Homework Evaluation successfully') {
        Utils.showToast('Homework Evaluate done for ${widget.studentName}');
        setState(() {
          isResponse = false;
        });
        Navigator.of(context).pop();
      } else {
        Utils.showToast('Something went wrong');
        setState(() {
          isResponse = false;
        });
      }
    }
  }
}
