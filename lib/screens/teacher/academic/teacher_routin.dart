import 'dart:async';
import 'dart:convert';
import 'package:edus_tutor/config/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import '../../../model/teachers_weekly_class.dart';

import '../../../utils/server/LogoutService.dart';

class TeacherMyRoutineScreen extends StatefulWidget {
  final bool isHome;
  const TeacherMyRoutineScreen({super.key, required this.isHome});

  @override
  State<TeacherMyRoutineScreen> createState() => _TeacherMyRoutineScreenState();
}

class _TeacherMyRoutineScreenState extends State<TeacherMyRoutineScreen> {
  List<String> weeks = AppFunction.weeks;
  var _token;

  bool isLoading = true;
  TeacherWeeklyClassResponse? weeklyClassResponse;

  Future<TeacherWeeklyClassResponse> getRoutine() async {
    try {
      _token = await Utils.getStringValue('token');

      final response = await http.get(
        Uri.parse(EdusApi.techersWeeklyClass),
        headers: Utils.setHeader(_token.toString()),
      );

      //  print(EdusApi.routineView(widget.id, "student", recordId: sectionId));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = TeacherWeeklyClassResponse.fromJson(jsonResponse);

        return data;
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e, t) {
      debugPrint(t.toString());
      debugPrint(e.toString());
      throw Exception(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      await Utils.getStringValue('token').then((tok) async {
        weeklyClassResponse = await getRoutine();
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  int initialIndex = 0;

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
    super.initState();
    getInitialDay();
    selectedDay = weeks[initialIndex];
    pageController = PageController(initialPage: initialIndex);
    fetchData();
  }

  String selectedDay = '';
  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: const BoxDecoration(color: Color(0xff053EFF)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(width: 25.w),
                if (!widget.isHome)
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 20,
                      )),
                if (widget.isHome) Container(width: 25.w),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      widget.isHome ? "TimeTable".tr : "TimeTable".tr,
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
      body:
          isLoading ? const Center(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        h16,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < weeks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = weeks[i];
                          pageController.jumpToPage(i);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: selectedDay == weeks[i]
                              ? const LinearGradient(
                                  colors: [Colors.lightBlue, Color(0xff053EFF)],
                                )
                              : const LinearGradient(
                                  colors: [Colors.grey, Colors.black45],
                                ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Text(
                            weeks[i].substring(0, 3).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: weeks.length,
            onPageChanged: (index) {
              setState(() {
                initialIndex = index;
                selectedDay = weeks[initialIndex];
              });
            },
            itemBuilder: (context, index) {
              final classes =
                  weeklyClassResponse?.data.weeklyClass[selectedDay] ?? [];
              if (classes.isEmpty) {
                return Utils.noDataWidget();
              }
              return ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, classIndex) {
                  return _tutionCard(context, classes[classIndex]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tutionCard(BuildContext context, TeachersClassDetail classDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.transparent,
        surfaceTintColor: Colors.white,
        child: Container(
          // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              // gradient: const LinearGradient(
              //   colors: [

              //   ],
              // ),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${'Time'.tr}:",
                      style: _textStyle(),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${classDetail.startTime} - ${classDetail.endTime}',
                        style: _textStyle(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${'Topic'.tr}:", style: _textStyle()),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(classDetail.topic ?? '', style: _textStyle()),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${'Class'.tr}:", style: _textStyle()),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(classDetail.classSection ?? '',
                          style: _textStyle()),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${'Status'.tr}:", style: _textStyle()),
                    const SizedBox(width: 5),
                    Expanded(
                      child:
                          Text(classDetail.status ?? '', style: _textStyle()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
  }
}
