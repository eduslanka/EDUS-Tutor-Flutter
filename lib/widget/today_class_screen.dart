import 'package:auto_size_text/auto_size_text.dart';
import 'package:edus_tutor/config/app_size.dart';
import 'package:edus_tutor/model/today_class_model.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/teacher_today_class_model.dart';

class TodayClassScreen extends StatefulWidget {
  final TodayClassResponse? studentResponse;
  final TeacherTodayClassResponse? teachersResponse;
  final String rule;
  const TodayClassScreen(
      {super.key,
      this.studentResponse,
      this.teachersResponse,
      required this.rule});

  @override
  State<TodayClassScreen> createState() => _TodayClassScreenState();
}

class _TodayClassScreenState extends State<TodayClassScreen> {
  @override
  Widget build(BuildContext context) {
    final classLen = widget.rule == '2'
        ? widget.studentResponse?.classes.length
        : widget.teachersResponse?.data.todayClass.length;
    final classes = widget.rule == '2'
        ? widget.studentResponse?.classes
        : widget.teachersResponse?.data.todayClass;
    return Container(
      child: classLen == 0
          ? Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                  child: Center(
                      child: Text(
                widget.rule == '2'
                    ? 'No Classes Today. You can study on your own, revise and practice past lessons..!'
                    : 'You have no classes scheduled today..!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ))),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      'Today Classes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      minFontSize: 8,
                      maxFontSize: 14,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              itemCount: classLen,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: ((context, index) {
                                TodayClass? classes;
                                TeacherClassDetail? techersClass;
                                if (widget.rule == '2') {
                                  classes =
                                      widget.studentResponse?.classes[index];
                                } else {
                                  techersClass = widget
                                      .teachersResponse?.data.todayClass[index];
                                }

                                bool isStudent = widget.rule == '2';
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 239, 239, 239),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: AutoSizeText(
                                              isStudent
                                                  ? classes?.classSec ?? ''
                                                  : techersClass
                                                          ?.classSection ??
                                                      '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                              minFontSize: 8,
                                              maxFontSize: 14,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: AutoSizeText(
                                              isStudent
                                                  ? classes?.startTime ?? ''
                                                  : techersClass?.startTime ??
                                                      '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                              minFontSize: 10,
                                              maxFontSize: 14,
                                              maxLines: 1,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isStudent) {
                                                  if (classes?.status ==
                                                      'Join') {
                                                    launchUrl(Uri.parse(
                                                        classes?.meetLink ??
                                                            ''));
                                                  }
                                                } else {
                                                  if (techersClass?.status ==
                                                      'Join') {
                                                    launchUrl(Uri.parse(
                                                        classes?.meetLink ??
                                                            ''));
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width:
                                                    screenWidth(100, context),
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: isStudent
                                                        ? classes?.status ==
                                                                'Join'
                                                            ? Utils.baseBlue
                                                            : Colors.white
                                                        : techersClass
                                                                    ?.status ==
                                                                'Join'
                                                            ? Utils.baseBlue
                                                            : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Center(
                                                    child: SizedBox(
                                                  width:
                                                      screenWidth(60, context),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      isStudent
                                                          ? classes?.cancelOrRescheduleStatus ==
                                                                  'false'
                                                              ? classes
                                                                      ?.status ??
                                                                  ''
                                                              : classes?.status ==
                                                                      'Join'
                                                                  ? classes
                                                                          ?.status ??
                                                                      ''
                                                                  : techersClass
                                                                          ?.cancelOrRescheduleStatus ??
                                                                      ''
                                                          : techersClass
                                                                      ?.cancelOrRescheduleStatus ==
                                                                  'false'
                                                              ? techersClass
                                                                      ?.status ??
                                                                  ''
                                                              : techersClass
                                                                          ?.status ==
                                                                      'Join'
                                                                  ? techersClass
                                                                          ?.status ??
                                                                      ''
                                                                  : techersClass
                                                                          ?.cancelOrRescheduleStatus ??
                                                                      '',
                                                      style: TextStyle(
                                                          color: isStudent
                                                              ? classes?.cancelOrRescheduleStatus ==
                                                                      'false'
                                                                  ? classes?.status ==
                                                                          'Join'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black
                                                                  : techersClass
                                                                              ?.status ==
                                                                          'Join'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red
                                                              : classes?.cancelOrRescheduleStatus ==
                                                                      'false'
                                                                  ? techersClass
                                                                              ?.status ==
                                                                          'Join'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black
                                                                  : techersClass
                                                                              ?.status ==
                                                                          'Join'
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .red,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      minFontSize: 6,
                                                      maxFontSize: 14,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                )),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
