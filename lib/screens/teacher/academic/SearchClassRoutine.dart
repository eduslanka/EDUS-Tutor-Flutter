// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/Classes.dart';
import 'package:edus_tutor/utils/model/Section.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';
import 'StudentRoutineListScreen.dart';

class SearchRoutineScreen extends StatefulWidget {
  const SearchRoutineScreen({super.key});

  @override
  _SearchRoutineScreenState createState() => _SearchRoutineScreenState();
}

class _SearchRoutineScreenState extends State<SearchRoutineScreen> {
  String? _id;
  dynamic classId;
  dynamic sectionId;
  String? _selectedClass;
  String? _selectedSection;
  Future? classes;
  Future<SectionList>? sections;
  String? _token;
  String? rule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
                print("classes : ${value.classes}");
                // _selectedClass = value.classes[0].name;
                _selectedClass = AllClasses.classes[0].name;
                classId = AllClasses.classes[0].id;
                sections = getAllSection(int.parse(_id ?? ''), classId);
                sections?.then((sectionValue) {
                  _selectedSection = sectionValue.sections[0].name;
                  sectionId = sectionValue.sections[0].id;
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
      appBar: CustomAppBarWidget(title: 'Search routine'),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: <Widget>[
                    getClassDropdown(snapshot.data.classes),
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
                  color: Colors.white, fontSize: ScreenUtil().setSp(16)),
            ),
          ),
        ),
        onTap: () {
          if (classId != null && sectionId != null) {
            Navigator.push(
                context, ScaleRoute(page: StudentRoutine(classId, sectionId)));
          } else {
            Utils.showToast('No Data Available');
          }
        },
      ),
    );
  }

  Widget getClassDropdown(List<Classes> classes) {
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
            _selectedSection = '$value';

            sectionId = getSectionCode(sectionlist, '$value');
          });
        },
        value: _selectedSection,
      ),
    );
  }

  int? getCode<T>(List<Classes> t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  int? getSectionCode<T>(List<Section> t, String title) {
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
    final response = await http.get(Uri.parse(EdusApi.getClassById(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      print("class : ${response.body}");
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
        Uri.parse(EdusApi.getSectionById(id, classId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return SectionList.fromJson(jsonData['data']['teacher_sections']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
