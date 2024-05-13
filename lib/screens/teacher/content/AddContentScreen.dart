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
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Classes.dart';
import 'package:infixedu/utils/model/Section.dart';
import 'package:infixedu/utils/model/TeacherSubject.dart';
import 'package:infixedu/utils/permission_check.dart';

class AddContentScreeen extends StatefulWidget {
  const AddContentScreeen({Key? key}) : super(key: key);

  @override
  _AddContentScreeenState createState() => _AddContentScreeenState();
}

class _AddContentScreeenState extends State<AddContentScreeen> {
  String? _id;
  dynamic classId;
  dynamic subjectId;
  dynamic sectionId;
  int classIndex = 0;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedContentType;
  String? _selectedaAssignDate;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController classController =
      TextEditingController(text: "Select class");
  Future? classes;
  Future<SectionList>? sections;
  Future<TeacherSubjectList>? subjects;
  TeacherSubjectList? subjectList;
  DateTime? date;
  String maxDateTime = '2031-11-25';
  String initDateTime = '2019-05-17';
  String? _format;
  DateTime? _dateTime;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  File? _file;
  bool isResponse = false;
  Response? response;
  Dio dio = Dio();
  String? rule;
  var contentType = ['Assignment'.tr, 'Syllabus'.tr, 'Other Downloads'.tr];
  String radioStr = 'admin';
  int allClasses = 0;

  String? _token;
  String? _schoolId;

  bool studentDropdown = false;
  bool allStudent = false;
  bool allAdmin = true;
  bool studentSelect = false;

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
    }).then((value) {
      Utils.getStringValue('rule').then((ruleValue) {
        rule = ruleValue;
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          _id = value;
          classes = getAllClass(int.parse(_id ?? ''));
          classes?.then((value) {
            if (AllClasses.classes.isNotEmpty) {
              _selectedClass = AllClasses.classes[0].name;
              classId = AllClasses.classes[0].id;
            }
            // _selectedClass = value.classes[0].name;
            // classId = value.classes[0].id;
            _selectedContentType = 'Assignment'.tr;
            sections = getAllSection(int.parse(_id ?? ''), classId);
            sections?.then((sectionValue) {
              if (sectionValue.sections.isNotEmpty) {
                _selectedSection = sectionValue.sections[0].name;
                sectionId = sectionValue.sections[0].id;
              }
              // _selectedSection = sectionValue.sections[0].name;
              // sectionId = sectionValue.sections[0].id;
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
        title: 'Add Content',
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: getContent(context),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: Utils.gradientBtnDecoration,
                child: Text(
                  "Save".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
              onTap: () {
                String title = titleController.text;
                String description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  setState(() {
                    isResponse = true;
                  });
                  uploadContent();
                } else {
                  Utils.showToast('Check all the field');
                }
              },
            ),
          ),
          isResponse == true
              ? const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                )
              : const Text(''),
        ],
      ),
    );
  }

  Widget getContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: FutureBuilder(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Text(
                      'Content Type'.tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    getContentTypeDropdown(),
                    const SizedBox(height: 20),
                    Text(
                      'Title'.tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.headlineMedium,
                      controller: titleController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        labelStyle: Theme.of(context).textTheme.headlineMedium,
                        errorStyle: const TextStyle(
                            color: Colors.pinkAccent, fontSize: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 0.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Available for'.tr,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(
                      height: 5,
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      groupValue: radioStr,
                      title: Text("All Admin".tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: ScreenUtil().setSp(12))),
                      value: 'admin',
                      activeColor: Colors.purple,
                      selected: radioStr == 'admin' ? true : false,
                      enableFeedback: false,
                      dense: true,
                      onChanged: (_) {
                        setState(() {
                          radioStr = 'admin';
                        });
                        setState(() {
                          studentDropdown = false;
                        });
                      },
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      groupValue: radioStr,
                      title: Text("Student".tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: ScreenUtil().setSp(12))),
                      value: 'student',
                      activeColor: Colors.purple,
                      enableFeedback: false,
                      selected: radioStr == 'student' ? true : false,
                      dense: true,
                      onChanged: (_) {
                        setState(() {
                          radioStr = 'student';
                        });
                        setState(() {
                          studentDropdown = true;
                        });
                      },
                    ),
                    studentDropdown
                        ? _studentListWidget(context)
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 0.5,
                        ),
                      ),
                      child: InkWell(
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
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _selectedaAssignDate ?? 'Assign Date'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: ScreenUtil().setSp(12)),
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
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 0.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          pickDocument();
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _file == null
                                    ? 'Select file'.tr
                                    : _file?.path.split('/').last ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        fontSize: ScreenUtil().setSp(12)),
                                maxLines: 2,
                              ),
                            ),
                            Text('Browse'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                        decoration: TextDecoration.underline)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: Theme.of(context).textTheme.headlineMedium,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Description".tr,
                        labelText: "Description".tr,
                        labelStyle: Theme.of(context).textTheme.headlineMedium,
                        errorStyle: const TextStyle(
                            color: Colors.pinkAccent, fontSize: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 0.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 0.5),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CupertinoActivityIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget getContentTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.deepPurpleAccent,
          width: 0.5,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          elevation: 0,
          isExpanded: true,
          items: contentType.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }).toList(),
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 15.0),
          onChanged: (value) {
            setState(() {
              _selectedContentType = '$value';
            });
          },
          value: _selectedContentType,
        ),
      ),
    );
  }

  void uploadContent() async {


    FormData formData = FormData.fromMap({
      "class": '$classId',
      "section": '$sectionId',
      "school_id": _schoolId,
      "upload_date": _selectedaAssignDate,
      "available_for": radioStr,
      "description": descriptionController.text,
      "created_by": _id,
      "all_classes": '$allClasses',
      "content_title": titleController.text,
      "content_type": _selectedContentType?.toLowerCase().substring(0, 2),
      "attach_file": _file != null
          ? await MultipartFile.fromFile(_file?.path ?? '',
              filename: _file?.path)
          : "",
    });
    response = await dio.post(
      InfixApi.uploadContent,
      data: formData,
      options: Options(
        // contentType: Headers.formUrlEncodedContentType,
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {}
      },
    ).catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
    });

    if (response?.statusCode == 200) {
      Utils.showToast('Upload successful');
      if (radioStr == 'admin') {
        sentNotificationTo(1);
      } else {
        if (allClasses == 1) {
          sentNotificationTo(2);
        } else {
          sentNotificationToSection(classId, sectionId);
        }
      }
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

  Future getAllClass(dynamic id) async {
    final response = await http.get(Uri.parse(InfixApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));


    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (rule == "1" || rule == "5") {

        print("rule : $rule => Classes : ${response.body}");
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
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  _studentListWidget(BuildContext context) {

    return FutureBuilder(
      future: classes,
      builder: (context, snapshot) {


        if (snapshot.hasData) {
          // final List classes = snapshot.data.toString() as List;

          //List<dynamic>? classes;
          if (snapshot.data != null) {
            try {
              //classes = jsonDecode(snapshot.data.toString()) as List<dynamic>;
            } catch (e, tr) {
              print('Error decoding JSON: $e');
              print(tr.toString());
            }
          }

        // print("Class :  ${AdminClassList.classes.length}");

          return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[
              CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: allStudent,
                  activeColor: Colors.purple,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text("All Student".tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 15.0)),
                  onChanged: (bool? value) {
                    setState(() {
                      allStudent = value ?? false;
                      allStudent ? allClasses = 1 : allClasses = 0;

                    });
                  }),


              if(!allStudent) SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Class",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 15.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.deepPurpleAccent,
                          width: 0.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          elevation: 0,
                          isExpanded: true,
                          items: AllClasses.classes.map((item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(item.name.toString()),
                              ),
                            );
                          }).toList(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 15.0),
                          onChanged: (value) {
                            setState(() {

                              _selectedClass = value;
                             // classController.text = adminClasses.name.toString();

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
                      ),
                    ),
                  ],
                ),
              ),

              if(!allStudent) const SizedBox(
                height: 10,
              ),

              if(!allStudent) FutureBuilder<SectionList>(
                future: sections,
                builder: (context, secSnap) {
                  if (secSnap.hasData) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Section",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 15.0),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.deepPurpleAccent,
                                  width: 0.5,
                                ),
                              ),
                              child: DropdownButton(
                                elevation: 0,
                                isExpanded: true,
                                items: secSnap.data?.sections.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.name,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(item.name ?? ''),
                                    ),
                                  );
                                }).toList(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 15.0),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSection = '$value';

                                    sectionId = getCode(
                                        secSnap.data!.sections, '$value');
                                  });
                                },
                                value: _selectedSection,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              const SizedBox(
                height: 10,
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 40),
              //   height: 50.0,
              //   child: GestureDetector(
              //     child: Container(
              //       padding: const EdgeInsets.all(10.0),
              //       alignment: Alignment.center,
              //       decoration: Utils.gradientBtnDecoration,
              //       child: Text(
              //         "Confirm".tr,
              //         style: Theme.of(context)
              //             .textTheme
              //             .headlineSmall
              //             ?.copyWith(color: Colors.white),
              //       ),
              //     ),
              //     onTap: () async {
              //       // Navigator.of(context, rootNavigator: true)
              //       //     .pop('dialog');

              //       if (allClasses == 1) {
              //         Utils.showToast("All Student selected");
              //       } else {
              //         Utils.showToast(
              //             "Selected Class: $_selectedClass, Section: $_selectedSection");
              //       }
              //     },
              //   ),
              // ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path ?? '');
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  void sentNotificationToSection(dynamic classCode, dynamic sectionCode) async {
    final response = await http.get(Uri.parse(
        InfixApi.sentNotificationToSection('Content',
            'New content request has come', '$classCode', '$sectionCode')));
    if (response.statusCode == 200) {}
  }

  void sentNotificationTo(dynamic role) async {
    final response = await http.get(Uri.parse(InfixApi.sentNotificationForAll(
        role, 'Content', 'New content request has come')));
    if (response.statusCode == 200) {}
  }
}
