// Flutter imports:
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/TeacherMyRoutine.dart';

import 'package:edus_tutor/utils/widget/RoutineRowWidget.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../controller/user_controller.dart';
import '../../../model/teachers_weekly_class.dart';

// ignore: must_be_immutable
class TeacherMyRoutineScreen extends StatefulWidget {
  final bool  isHome;
  const TeacherMyRoutineScreen({Key? key,required this.isHome}) : super(key: key);

  @override
  State<TeacherMyRoutineScreen> createState() => _TeacherMyRoutineScreenState();
}

class _TeacherMyRoutineScreenState extends State<TeacherMyRoutineScreen> with SingleTickerProviderStateMixin {
  // List<String> weeks = AppFunction.weeks;

  // var _token;

  // var _id;

  // Future<TeacherRoutine?> getRoutine() async {
  //   TeacherRoutine? data;
  //   await Utils.getStringValue('id').then((id) {
  //     _id = id;
  //   }).then((value) async {
  //     await Utils.getStringValue('token').then((token) {
  //       _token = token;
  //     });
  //   }).then((value) async {
  //     final response = await http.get(
  //         Uri.parse(EdusApi.techersWeeklyClass),
  //         headers: Utils.setHeader(_token.toString()));
  //     if (response.statusCode == 200) {
  //       data = teacherRoutineFromJson(response.body);
  //     } else {
  //       // If that response was not OK, throw an error.
  //       throw Exception('Failed to load post');
  //     }
  //   });
  //   return data;
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        isAcadamic: widget.isHome,
        title: "Time Table",
      ),
      body: routinBody(),
    );
  }

  // Padding oldbody() {
  //   return Padding(
  //         padding: const EdgeInsets.only(top: 16.0, left: 10.0, right: 10.0),
  //         child: FutureBuilder<TeacherRoutine?>(
  //           future: getRoutine(),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasData) {
  //               if (snapshot.data!.classRoutines!.isNotEmpty) {
  //                 return ListView.builder(
  //                     physics: const NeverScrollableScrollPhysics(),
  //                     shrinkWrap: true,
  //                     itemCount: weeks.length,
  //                     itemBuilder: (context, index) {
  //                       List<ClassRoutine>? classRoutines = snapshot
  //                           .data?.classRoutines
  //                           ?.where((element) => element.day == weeks[index])
  //                           .toList();

  //                       return classRoutines!.isEmpty
  //                           ? Container()
  //                           : Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: <Widget>[
  //                                 Padding(
  //                                   padding:
  //                                       const EdgeInsets.only(bottom: 8.0),
  //                                   child: Text(weeks[index],
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .titleLarge
  //                                           ?.copyWith()),
  //                                 ),
  //                                 Padding(
  //                                   padding:
  //                                       const EdgeInsets.only(bottom: 5.0),
  //                                   child: Row(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: <Widget>[
  //                                       Expanded(
  //                                         flex: 2,
  //                                         child: Text('Time'.tr,
  //                                             style: Theme.of(context)
  //                                                 .textTheme
  //                                                 .headlineMedium
  //                                                 ?.copyWith()),
  //                                       ),
  //                                       Expanded(
  //                                         flex: 2,
  //                                         child: Text('Class'.tr,
  //                                             style: Theme.of(context)
  //                                                 .textTheme
  //                                                 .headlineMedium
  //                                                 ?.copyWith()),
  //                                       ),
  //                                       Expanded(
  //                                         flex: 1,
  //                                         child: Text('Room'.tr,
  //                                             style: Theme.of(context)
  //                                                 .textTheme
  //                                                 .headlineMedium
  //                                                 ?.copyWith()),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 ListView.builder(
  //                                   physics: const NeverScrollableScrollPhysics(),
  //                                   itemCount: classRoutines.length,
  //                                   shrinkWrap: true,
  //                                   itemBuilder: (context, rowIndex) {
  //                                     return RoutineRowDesignTeacher(
  //                                       '${classRoutines[rowIndex].startTime}' +
  //                                           '-' +
  //                                           '${classRoutines[rowIndex].endTime}',
  //                                       classRoutines[rowIndex].subject ?? '',
  //                                       classRoutines[rowIndex].room ?? '',
  //                                       classRoutineClass:
  //                                           classRoutines[rowIndex]
  //                                               .classRoutineClass ?? '',
  //                                       section:
  //                                           classRoutines[rowIndex].section ?? '',
  //                                     );
  //                                   },
  //                                 ),
  //                                 Padding(
  //                                   padding: const EdgeInsets.only(top: 8.0),
  //                                   child: Container(
  //                                     height: 0.5,
  //                                     decoration: const BoxDecoration(
  //                                       color: Color(0xFF415094),
  //                                     ),
  //                                   ),
  //                                 )
  //                               ],
  //                             );
  //                     });
  //               } else {
  //                 return const Text("");
  //               }
  //             } else {
  //               return const Center(
  //                 child: CupertinoActivityIndicator(),
  //               );
  //             }
  //           },
  //         ),
  //       );
  // }
  
  
  TabController? _tabController;
  final UserController _userController = Get.put(UserController());
  List<String> weeks = AppFunction.weeks;
  var _token;
  Future<TeacherWeeklyClassResponse>? routine;
  bool isLoading = true;
  Future<TeacherWeeklyClassResponse> getRoutine() async {
    try {
   _token=   await Utils.getStringValue('token');
 
      final response = await http.get(Uri.parse(EdusApi.techersWeeklyClass),
          headers: Utils.setHeader(_token.toString()),);

      //  print(EdusApi.routineView(widget.id, "student", recordId: sectionId));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = TeacherWeeklyClassResponse.fromJson(jsonResponse);
      
        return data;
      } else {
       
        throw Exception('Failed to load post');
      }
    } catch (e,t) {
      debugPrint(t.toString());
      debugPrint(e.toString());
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
   Padding routinBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<TeacherWeeklyClassResponse>(
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
                                                                      'Status'.tr +
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
                                                                        classDetail?.status ??
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
                                                                      'Section'
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
