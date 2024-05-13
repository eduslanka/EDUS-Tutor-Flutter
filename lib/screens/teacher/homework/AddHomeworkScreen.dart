// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as bs;
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/utils/model/Section.dart';
import 'package:infixedu/utils/model/TeacherSubject.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:infixedu/utils/widget/image_pick_dialog.dart';

class AddHomeworkScrren extends StatefulWidget {
  const AddHomeworkScrren({Key? key}) : super(key: key);

  @override
  _AddHomeworkScrrenState createState() => _AddHomeworkScrrenState();
}

class _AddHomeworkScrrenState extends State<AddHomeworkScrren> {
  String? _id;
  dynamic classId;
  dynamic subjectId;
  dynamic sectionId;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedSubject;
  String? _selectedaAssignDate;
  String? _selectedSubmissionDate;
  TextEditingController markController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Future? classes;
  Future<SectionList>? sections;
  Future<TeacherSubjectList>? subjects;
  TeacherSubjectList? subjectList;
  DateTime? date;
  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  final String _format = 'yyyy-MMMM-dd';
  DateTime? _dateTime;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File? _file;
  bool isResponse = false;
  Response? response;
  Dio dio = Dio();
  String? _token;
  final _formKey = GlobalKey<FormState>();
  String? _schoolId;
  String? rule;

  bool isScroll = false;

  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    Utils.getStringValue('schoolId').then((value) {
      setState(() {
        _schoolId = value;
      });
    });
    date = DateTime.now();
    initDateTime =
        '${date?.year}-${getAbsoluteDate(date?.month ?? 0)}-${getAbsoluteDate(date?.day ?? 0)}';
    _dateTime = DateTime.parse(initDateTime);
    PermissionCheck().checkPermissions(context);

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          _id = value;
          Utils.getStringValue('rule').then((ruleValue) {
            setState(() {
              rule = ruleValue;
              classes = getAllClass(int.parse(_id ?? ''));
              classes?.then((value) {
                if(AllClasses.classes.isNotEmpty){
                  _selectedClass = AllClasses.classes[0].name;
                  classId = AllClasses.classes[0].id;
                }
                sections = getAllSection(int.parse(_id ?? ''), classId);
                sections?.then((sectionValue) {
                  if(sectionValue.sections.isNotEmpty){
                    _selectedSection = sectionValue.sections[0].name;
                    sectionId = sectionValue.sections[0].id;
                  }

                  subjects = getAllSubject(int.parse(_id ?? ''));
                  subjects?.then((subVal) {
                    setState(() {
                      subjectList = subVal;
                      if(subVal.subjects.isNotEmpty){
                        subjectId = subVal.subjects[0].subjectId;
                        _selectedSubject = subVal.subjects[0].subjectName;
                      }
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Add Homework',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: scrollController,
          child: getContent(context),
      ),
      // bottomNavigationBar: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     GestureDetector(
      //       child: Padding(
      //         padding: const EdgeInsets.all(10.0),
      //         child: Container(
      //           alignment: Alignment.center,
      //           width: MediaQuery.of(context).size.width,
      //           height: 50.0,
      //           decoration: Utils.gradientBtnDecoration,
      //           child: Text(
      //             "Save".tr,
      //             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      //                 color: Colors.white, fontSize: ScreenUtil().setSp(14)),
      //           ),
      //         ),
      //       ),
      //       onTap: () {
      //
      //         String mark = markController.text;
      //         String description = descriptionController.text;
      //
      //         if (mark.isNotEmpty && description.isNotEmpty) {
      //           setState(() {
      //             isResponse = true;
      //           });
      //           uploadHomework();
      //         } else {
      //           Utils.showToast('Check all the field'.tr);
      //         }
      //       },
      //     ),
      //     isResponse == true ? const LinearProgressIndicator(backgroundColor: Colors.transparent) : const Text(''),
      //     5.verticalSpace,
      //   ],
      // ),
    );
  }

  Widget getContent(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder(
          future: classes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                //physics: const NeverScrollableScrollPhysics(),
               // shrinkWrap: true,
                children: <Widget>[
                  getClassDropdown(snapshot.data.classes),
                  FutureBuilder<SectionList>(
                    future: sections,
                    builder: (context, secSnap) {
                      if (secSnap.hasData) {
                        return getSectionDropdown(secSnap.data?.sections ?? []);
                      } else if (secSnap.connectionState.name == 'waiting') {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (secSnap.connectionState.name == 'none') {
                        return getClassDropdown([]);
                      }  else {
                        return const Center(child: CupertinoActivityIndicator());
                      }
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FutureBuilder<TeacherSubjectList>(
                    future: subjects,
                    builder: (context, subSnap) {
                      if (subSnap.hasData) {
                        return getSubjectDropdown(subSnap.data?.subjects ?? []);
                      } else if (subSnap.connectionState.name == 'waiting') {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (subSnap.connectionState.name == 'none') {
                        return getClassDropdown([]);
                      }  else {
                        return const Center(child: CupertinoActivityIndicator());
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              pickerTheme: const DateTimePickerTheme(
                confirm: Text('Done',
                    style: TextStyle(color: Colors.red)),
                cancel: Text('cancel',
                    style: TextStyle(color: Colors.cyan)),
              ),
              minDateTime: DateTime.parse(initDateTime),
              maxDateTime: DateTime.parse(maxDateTime),
              initialDateTime: _dateTime,
              dateFormat: _format,
              locale: _locale,
              onClose: () => debugPrint("----- onClose -----"),
              onCancel: () => debugPrint('onCancel'),
              onChange: (dateTime, List<int> index) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
              onConfirm: (dateTime, List<int> index) {
                setState(() {
                  setState(() {
                    _dateTime = dateTime;
                    _selectedaAssignDate =
                    '${_dateTime?.year}-${getAbsoluteDate(_dateTime?.month ?? 0)}-${getAbsoluteDate(_dateTime?.day ?? 0)}';
                  });
                });
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 8.0),
                    child: Text(
                      _selectedaAssignDate ?? 'Assign Date'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                          fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black12,
                  size: ScreenUtil().setSp(16),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            DatePicker.showDatePicker(
              context,
              pickerTheme: const DateTimePickerTheme(
                confirm: Text('Done',
                    style: TextStyle(color: Colors.red)),
                cancel: Text('cancel',
                    style: TextStyle(color: Colors.cyan)),
              ),
              minDateTime: DateTime.parse(initDateTime),
              maxDateTime: DateTime.parse(maxDateTime),
              initialDateTime: _dateTime,
              dateFormat: _format,
              locale: _locale,
              onClose: () => debugPrint("----- onClose -----"),
              onCancel: () => debugPrint('onCancel'),
              onChange: (dateTime, List<int> index) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
              onConfirm: (dateTime, List<int> index) {
                setState(() {
                  setState(() {
                    _dateTime = dateTime;
                    _selectedSubmissionDate =
                    '${_dateTime?.year}-${getAbsoluteDate(_dateTime?.month ?? 0)}-${getAbsoluteDate(_dateTime?.day ?? 0)}';
                  });
                });
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 8.0),
                    child: Text(
                      _selectedSubmissionDate ?? 'Submission Date'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                          fontSize: ScreenUtil().setSp(12)),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black12,
                  size: ScreenUtil().setSp(16),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            //pickDocument();
            imagePickFrom();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      _file == null
                          ? 'Select file'.tr
                          : _file?.path ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                          fontSize: ScreenUtil().setSp(12)),
                      maxLines: 2,
                    ),
                  ),
                ),
                Text('Browse'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                        decoration:
                        TextDecoration.underline)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.headlineMedium,
            controller: markController,
            decoration: InputDecoration(
                hintText: "Marks".tr,
                labelText: "Marks".tr,
                labelStyle: Theme.of(context).textTheme.headlineMedium,
                errorStyle: const TextStyle(
                    color: Colors.pinkAccent, fontSize: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.headlineMedium,
            controller: descriptionController,
            decoration: InputDecoration(
                hintText: "Description".tr,
                labelText: "Description".tr,
                labelStyle: Theme.of(context).textTheme.headlineMedium,
                errorStyle: const TextStyle(
                    color: Colors.pinkAccent, fontSize: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )
            ),
          ),
        ),

        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: Utils.gradientBtnDecoration,
              child: Text(
                "Save".tr,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white, fontSize: ScreenUtil().setSp(14)),
              ),
            ),
          ),
          onTap: () {

            String mark = markController.text;
            String description = descriptionController.text;

            if (mark.isNotEmpty && description.isNotEmpty) {
              setState(() {
                isResponse = true;
              });
              uploadHomework();
            } else {
              Utils.showToast('Check all the field'.tr);
            }
          },
        ),
        isResponse == true ? const LinearProgressIndicator(backgroundColor: Colors.transparent) : const Text(''),
        5.verticalSpace,

        const SizedBox(height: 300),

      ],
    );
  }

  Widget getClassDropdown(List<Classes> classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: AllClasses.classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10),
              child: Text(
                item.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: ScreenUtil().setSp(14)),
        onChanged: (value) {
          setState(() {

            _selectedClass = value;

            int classIndex = AllClasses.classes.indexWhere((element) => value == element.name);
            //classId = getCode(classes, '$value');
            classId = AllClasses.classes[classIndex].id;

            sections = getAllSection(int.parse(_id ?? ''), classId);
            sections?.then((sectionValue) {
              _selectedSection =
                  sectionValue.sections[0].name;
              sectionId = sectionValue.sections[0].id;
            });
          });
        },
        value: _selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sectionlist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10),
              child:
                  Text(item.name ?? '', style: Theme.of(context).textTheme.headlineMedium),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: ScreenUtil().setSp(15.0)),
        onChanged: (value) {
          setState(() {
            _selectedSection = '$value';

            sectionId = getCode(sectionlist, '$value');
          });
        },
        value: _selectedSection,
      ),
    );
  }

  Widget getSubjectDropdown(List<TeacherSubject> subjectList) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: subjectList.map((item) {
          return DropdownMenuItem<String>(
            value: item.subjectName,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10),
              child: Text(
                item.subjectName ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            _selectedSubject = '$value';
             //subjectId = getSubjectId(subjectList, '$value');
            int subjectIndex = subjectList.indexWhere((element) => element.subjectName == value);
            subjectId = subjectList[subjectIndex].subjectId;
            print("Subject code : $subjectId");
          });
        },
        value: _selectedSubject,
      ),
    );
  }

  void uploadHomework() async {

    FormData formData = FormData.fromMap({
      "class_id": '$classId',
      "section_id": '$sectionId',
      "subject_id": '$subjectId',
      "marks": markController.text,
      "created_by": _id,
      "homework_date": _selectedaAssignDate,
      "submission_date": _selectedSubmissionDate,
      "school_id": _schoolId,
      "description": descriptionController.text,
      if(_file != null) "homework_file": await MultipartFile.fromFile(_file?.path ?? ''),

    });
    response = await dio.post(
      InfixApi.uploadHomework,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
        }
      },
    ).catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showToast(errorMessage);
    });
    if (response?.statusCode == 200) {
      Utils.showToast('Upload successful'.tr);
      Navigator.pop(context);
    }
  }

  int? getCode<T>(List t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future getAllClass(int id) async {

    final response = await http.get(Uri.parse(InfixApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (rule == "1" || rule == "5") {
        return AdminClassList.fromJson(jsonData['data']['teacher_classes']);
      } else {
        return ClassList.fromJson(jsonData['data']['teacher_classes']);
      }
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SectionList> getAllSection(dynamic id, dynamic classId) async {
    final response = await http.get(
        Uri.parse(InfixApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    print("Section : ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<TeacherSubjectList> getAllSubject(int id) async {

    try{
      final response = await http.get(Uri.parse(InfixApi.getTeacherSubject(id)),
          headers: Utils.setHeader(_token.toString()));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        return TeacherSubjectList.fromJson(jsonData['data']['subjectsName']);
      } else {
        throw Exception('Failed to load');
      }
    } catch(e, t){
      debugPrint('$e');
      debugPrint('$t');
    }
    return TeacherSubjectList.fromJson([]);
  }

  int? getSubjectId<T>(List t, String subject) {
    int? code;
    for (var s in t) {

      if (s.name == subject) {
        code = s.subjectId;
      }
    }
    return code;
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  void imagePickFrom(){

    bs.Get.bottomSheet(
      ImagePickDialog(
          onCameraTap: (){
            pickDocument(isCamera: true);
            bs.Get.back();
          },
          onGalleryTap:  (){
            pickDocument(isCamera: false);
            bs.Get.back();
          },
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      )
    );
  }

  Future pickDocument({required bool isCamera}) async {

    FilePickerResult? result;
    XFile? imagePicker;

    if(isCamera){
      imagePicker = await ImagePicker().pickImage(source: ImageSource.camera);
    }else{
      result = await FilePicker.platform.pickFiles();
    }

    if (imagePicker != null && isCamera) {

      setState(() {
        _file = File(imagePicker?.path ?? '');
      });
    }else if (result != null && !isCamera) {
      setState(() {
         _file = File(result?.files.single.path ?? '');
      });
    } else {
      Utils.showToast('Cancelled'.tr);
    }
  }

  void sentNotificationToSection(dynamic classCode, dynamic sectionCode) async {
    final response = await http.get(Uri.parse(
        InfixApi.sentNotificationToSection('Homework',
            'New homework has been uploaded', '$classCode', '$sectionCode')));
    if (response.statusCode == 200) {}
  }

  void permissionsDenied(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return SimpleDialog(
            title: Text("Permission denied".tr),
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                child: Text(
                  "You must grant all permission to use this application".tr,
                  style: const TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            ],
          );
        });
  }

  void setScroller(){
    scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
