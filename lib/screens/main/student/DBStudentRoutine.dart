import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Project imports:
import 'package:edus_tutor/controller/user_controller.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/StudentRecordWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:edus_tutor/utils/server/LogoutService.dart';
import '../../../model/weekly_class_model.dart';

class DBStudentRoutine extends StatefulWidget {
  final String? id;
  final bool isHome;
  const DBStudentRoutine({Key? key, this.id, required this.isHome})
      : super(key: key);

  @override
  _DBStudentRoutineState createState() => _DBStudentRoutineState();
}

class _DBStudentRoutineState extends State<DBStudentRoutine>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final UserController _userController = Get.put(UserController());
  List<String> weeks = AppFunction.weeks;
  var _token;
  Future<WeeklyClassResponse>? routine;
  bool isLoading = true;
  Future<WeeklyClassResponse> getRoutine() async {
    try {
   _token=   await Utils.getStringValue('token');
 
      final response = await http.post(Uri.parse(EdusApi.studentWeeklyClass),
          headers: Utils.setHeader(_token.toString()),);

      //  print(EdusApi.routineView(widget.id, "student", recordId: sectionId));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = WeeklyClassResponse.fromJson(jsonResponse);
        print('Response: ${response.body}');
        return data;
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load post');
      }
    } catch (e,t) {
      print(t);
      print(e);
      throw Exception(e.toString());
    } finally {
      setState(() {
        isLoading = true;
      });
    }
  }

  int? initialIndex = 0;

  void getInitialDay() {
    DateTime now = DateTime.now();
    final today = DateFormat('EEEE').format(now);
    setState(() {
      switch (today) {
        case "Saturday":
          initialIndex = 0;
          break;
        case "Sunday":
          initialIndex = 1;
          break;
        case "Monday":
          initialIndex = 2;
          break;
        case "Tuesday":
          initialIndex = 3;
          break;
        case "Wednesday":
          initialIndex = 4;
          break;
        case "Thursday":
          initialIndex = 5;
          break;
        case "Friday":
          initialIndex = 6;
          break;
      }
    });
  }

  @override
  void initState() {
    // getInitialDay();
    // routine = getRoutine();
    _tabController = TabController(
        length: weeks.length, initialIndex: initialIndex ?? 0, vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
 //   _userController.selectedRecord.value = _userController.studentRecord.value.records?.first ?? Record();
    await Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        routine =  getRoutine();
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(color: Color(0xff053EFF)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(width: 25.w),
                if (widget.isHome)
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20,
                      )),
                if (widget.isHome) Container(width: 25.w),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      widget.isHome ? "Classes".tr : "TimeTable".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    Get.dialog(LogoutService().logoutDialog());
                  },
                  icon: Icon(Icons.exit_to_app, size: 25.sp),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      body: routinBody(),
    );
  }

  Padding routinBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<WeeklyClassResponse>(
                    future: routine,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else {
                        if (snapshot.hasData) {
                          if (snapshot.data!.data.weeklyClass.isNotEmpty) {
                            return Column(
                              children: [
                                PreferredSize(
                                  preferredSize: const Size.fromHeight(0),
                                  child: TabBar(
                                    isScrollable: true,
                                    controller: _tabController,
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.0),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.lightBlue,
                                          Color(0xff053EFF)
                                        ],
                                      ),
                                    ),
                                    labelColor: Colors.white,
                                    onTap: (index) {
                                      setState(() {
                                        routine = getRoutine();
                                      });
                                    },
                                    unselectedLabelColor:
                                        const Color(0xFF415094),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    automaticIndicatorColorAdjustment: true,
                                    tabs: List.generate(
                                      weeks.length,
                                      (index) => Tab(
                                        height: 24,
                                        text: weeks[index]
                                            .substring(0, 3)
                                            .toUpperCase(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: PreferredSize(
                                    preferredSize: const Size.fromHeight(0),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: List.generate(
                                        weeks.length,
                                        (index) {
                                          Map<String, List<ClassDetail>>
                                              classRoutines =
                                              snapshot.data!.data.weeklyClass;

                                          return classRoutines.isEmpty
                                              ? Utils.noDataWidget()
                                              : Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                  child: ListView.separated(
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    itemCount: classRoutines[weeks[
                                                                _tabController!
                                                                    .index]]
                                                            ?.length ??
                                                        1,
                                                    shrinkWrap: true,
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        height: 0.2,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                        decoration:
                                                            const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerRight,
                                                            end: Alignment
                                                                .centerLeft,
                                                            colors: [
                                                              Color(0xff053EFF),
                                                              Color(0xff053EFF)
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    itemBuilder:
                                                        (context, rowIndex) {
                                                      final classDetail =
                                                          classRoutines[weeks[
                                                                  _tabController!
                                                                      .index]]
                                                              ?[rowIndex];

                                                      return classDetail
                                                                  ?.topic ==
                                                              null
                                                          ? Utils.noDataWidget()
                                                          : Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Time'.tr +
                                                                          ":",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineMedium
                                                                          ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        classDetail?.startTime !=
                                                                                null
                                                                            ? '${classDetail?.startTime} - ${classDetail?.endTime}'
                                                                            : "",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Topic'.tr +
                                                                          ":",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineMedium
                                                                          ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        classDetail?.topic ??
                                                                            '',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Subject'.tr +
                                                                          ":",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineMedium
                                                                          ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        classDetail?.classSection ??
                                                                            '',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      'Teacher'
                                                                              .tr +
                                                                          ":",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headlineMedium
                                                                          ?.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        classDetail?.teacher ??
                                                                            '',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium
                                                                            ?.copyWith(
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    height: 10),
                                                              
                                                              ],
                                                            );
                                                    },
                                                  ),
                                                );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Utils.noDataWidget();
                          }
                        } else if (snapshot.hasError) {
                          return Utils.noDataWidget();
                        } else {
                          return Utils.noDataWidget();
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
