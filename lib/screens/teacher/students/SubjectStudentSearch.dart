import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;
import 'package:edus_tutor/screens/teacher/students/SubjectStudentListScreen.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/Classes.dart';
import 'package:edus_tutor/utils/model/Section.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';
import '../../../utils/model/SubjectModel.dart';

// ignore: must_be_immutable
class SubjectStudentSearch extends StatefulWidget {
  String? status;

  SubjectStudentSearch({super.key, this.status});

  @override
  _SubjectStudentSearchState createState() =>
      // ignore: no_logic_in_create_state
      _SubjectStudentSearchState(status: status);
}

class _SubjectStudentSearchState extends State<SubjectStudentSearch> {
  String? _id;
  dynamic classId;
  dynamic sectionId;
  String? _selectedClass;
  String? _selectedSection;
  TextEditingController nameController = TextEditingController();
  TextEditingController rollController = TextEditingController();
  Future? classes;
  Future<SectionList>? sections;
  String? url;
  String? status;
  String? _token;
  String? rule;
  Future<SubjectModelList>? subjects;
  String? _selectedSubject;
  dynamic subjectId;
  _SubjectStudentSearchState({this.status});

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });

      Utils.getStringValue('rule').then((ruleValue) {
        setState(() {
          rule = ruleValue;
          Utils.getStringValue('id').then((value) {
            setState(() {
              _id = value;
              classes = getAllClass(int.parse(_id ?? ''));
              classes?.then((value) {
                _selectedClass = AllClasses.classes[0].name;
                classId = AllClasses.classes[0].id;
                sections = getAllSection(int.parse(_id ?? ''), classId);
                sections?.then((sectionValue) {
                  _selectedSection = sectionValue.sections[0].name;
                  sectionId = sectionValue.sections[0].id;

                  subjects = getAllSubject(classId, sectionId);
                  subjects?.then((subjectValue) {
                    setState(() {
                      _selectedSubject = subjectValue.subjects[0].name;
                      subjectId = subjectValue.subjects[0].id;
                      url = EdusApi.getStudentByClassAndSection(
                          classId, sectionId);
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
      appBar: CustomAppBarWidget(title: 'Subjectwise Attendance'),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    getClassDropdown([]),
                    FutureBuilder<SectionList>(
                      future: sections,
                      builder: (context, secSnap) {
                        if (secSnap.hasData) {
                          return getSectionDropdown(
                              secSnap.data?.sections ?? []);
                        } else if (secSnap.connectionState.name == 'waiting') {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (secSnap.connectionState.name == 'none') {
                          return getClassDropdown([]);
                        } else {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FutureBuilder<SubjectModelList>(
                      future: subjects,
                      builder: (context, subSnap) {
                        if (subSnap.hasData) {
                          return getSubjectDropdown(
                              subSnap.data?.subjects ?? []);
                        } else if (subSnap.connectionState.name == 'waiting') {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (subSnap.connectionState.name == 'none') {
                          return getClassDropdown([]);
                        } else {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.headlineMedium,
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: "Search by name".tr,
                            labelText: "Name".tr,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            errorStyle: const TextStyle(
                                color: Colors.blue, fontSize: 15.0),
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
                        controller: rollController,
                        decoration: InputDecoration(
                            hintText: "Search by roll".tr,
                            labelText: "Roll".tr,
                            labelStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            errorStyle: const TextStyle(
                                color: Colors.blue, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
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
      ),
      bottomNavigationBar: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            decoration: Utils.gradientBtnDecoration,
            child: Text(
              "Search".tr,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white, fontSize: ScreenUtil().setSp(14)),
            ),
          ),
        ),
        onTap: () {
          String name = nameController.text;
          String roll = rollController.text;

          if (name.isNotEmpty) {
            url = EdusApi.getStudentByName(name, classId, sectionId);
            Navigator.push(
              context,
              ScaleRoute(
                page: SubjectStudentListScreen(
                    classCode: classId,
                    sectionCode: sectionId,
                    subjectCode: subjectId,
                    url: url,
                    status: status,
                    token: _token,
                    subjectName: _selectedSubject),
              ),
            );
          } else if (roll.isNotEmpty) {
            url = EdusApi.getStudentByRoll(roll, classId, sectionId);
            Navigator.push(
                context,
                ScaleRoute(
                    page: SubjectStudentListScreen(
                        classCode: classId,
                        sectionCode: sectionId,
                        subjectCode: subjectId,
                        url: url,
                        status: status,
                        token: _token,
                        subjectName: _selectedSubject)));
          } else {
            url = EdusApi.getStudentBySubject(classId, sectionId, subjectId);
            Navigator.push(
                context,
                ScaleRoute(
                    page: SubjectStudentListScreen(
                        classCode: classId,
                        sectionCode: sectionId,
                        subjectCode: subjectId,
                        url: url,
                        status: status,
                        token: _token,
                        subjectName: _selectedSubject)));
          }
//
//                          if (!name.isEmpty) {
//                            Utils.showToast('$name');
//                            Navigator.push(
//                                context,
//                                ScaleRoute(
//                                    page: StudentListScreen(
//                                  name: name,
//                                )));
//                          } else if (!roll.isEmpty) {
//                            Utils.showToast('$roll');
//                            Navigator.push(
//                                context,
//                                ScaleRoute(
//                                    page: StudentListScreen(
//                                  roll: roll,
//                                )));
//                          } else {
//                            Navigator.push(
//                                context,
//                                ScaleRoute(
//                                    page: StudentListScreen(
//                                  classCode: classId,
//                                  sectionCode: sectionId,
//                                )));
//                          }
        },
      ),
    );
  }

  Widget getClassDropdown(List classes) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: AllClasses.classes.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
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
            ?.copyWith(fontSize: ScreenUtil().setSp(15)),
        onChanged: (value) {
          setState(() {
            _selectedClass = '$value';

            int classIndex = AllClasses.classes
                .indexWhere((element) => value == element.name);
            //classId = getCode(classes, '$value');
            classId = AllClasses.classes[classIndex].id;

            sections = getAllSection(int.parse(_id ?? ''), classId);
            sections?.then((sectionValue) {
              _selectedSection = sectionValue.sections[0].name;
              sectionId = sectionValue.sections[0].id;
            });

            debugPrint('User select class $classId');
          });
        },
        value: _selectedClass,
      ),
    );
  }

  Widget getSectionDropdown(List<Section> sectionlist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: sectionlist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
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
            ?.copyWith(fontSize: ScreenUtil().setSp(15)),
        onChanged: (value) {
          setState(() {
            _selectedSection = '$value';

            sectionId = getCode(sectionlist, '$value');

            sections = getAllSection(int.parse(_id ?? ''), classId);

            debugPrint('User select section $sectionId');
          });
        },
        value: _selectedSection,
      ),
    );
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
    final response = await http.get(Uri.parse(EdusApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));
    try {
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
    } catch (e, t) {
      debugPrint('$e');
      debugPrint('$t');
    }
  }

  Widget getSubjectDropdown(List<SubjectModel> subjectModellist) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: subjectModellist.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(item.name ?? '',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: ScreenUtil().setSp(15)),
        onChanged: (value) {
          setState(() {
            _selectedSubject = '$value';

            subjectId = getCode(subjectModellist, '$value');

            url = EdusApi.getStudentByClassAndSection(classId, sectionId);

            debugPrint('User select subject $subjectId');
          });
        },
        value: _selectedSubject,
      ),
    );
  }

  Future<SectionList> getAllSection(dynamic id, dynamic classId) async {
    final response = await http.get(
        Uri.parse(EdusApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<SubjectModelList> getAllSubject(int classId, int sectionId) async {
    final response = await http.post(
        Uri.parse(EdusApi.getSubjectById(classId, sectionId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SubjectModelList.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }
}
