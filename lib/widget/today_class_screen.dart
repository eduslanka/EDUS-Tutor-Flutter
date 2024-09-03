import 'package:auto_size_text/auto_size_text.dart';
import 'package:edus_tutor/model/today_class_model.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/teacher_today_class_model.dart';

class TodayClassScreen extends StatefulWidget {
  final TodayClassResponse? studentResponse;
  final TeacherTodayClassResponse? teachersResponse;
  final String rule;

  const TodayClassScreen({
    Key? key,
    this.studentResponse,
    this.teachersResponse,
    required this.rule,
  }) : super(key: key);

  @override
  State<TodayClassScreen> createState() => _TodayClassScreenState();
}

class _TodayClassScreenState extends State<TodayClassScreen> {
  Future<void> googleMeet(String meetUrl) async {
    if (await canLaunch(meetUrl)) {
      await launch(meetUrl);
    } else {
      throw 'Could not launch $meetUrl';
    }
  }

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
          ? _buildNoClassesMessage()
          : _buildClassesList(classLen, classes, widget.rule),
    );
  }

  Widget _buildNoClassesMessage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Text(
          widget.rule == '2'
              ? 'No Classes Today. You can study on your own, revise and practice past lessons..!'
              : 'You have no classes scheduled today..!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildClassesList(int? classLen, dynamic classes, String rule) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AutoSizeText(
              'Today Classes 📚',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              minFontSize: 8,
              maxFontSize: 14,
              maxLines: 1,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    itemCount: classLen,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildClassItem(classes, index, rule);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassItem(dynamic classes, int index, String rule) {
    bool isStudent = rule == '2';
    TodayClass? studentClass;
    TeacherClassDetail? teacherClass;

    if (isStudent) {
      studentClass = classes?[index];
    } else {
      teacherClass = classes?[index];
    }



    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 239, 239, 239),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildClassSection(isStudent, studentClass, teacherClass),
                  _buildStartTime(isStudent, studentClass, teacherClass),
                  _buildJoinButton(isStudent, studentClass, teacherClass),
                ],
              ),
              if (isStudent&& isRescheduled==studentClass &&isClicked || !isStudent&& selectedClass==teacherClass&&isClicked) _buildRescheduledDetails(isStudent, studentClass, teacherClass),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassSection(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    return Expanded(
      flex: 7,
      child: AutoSizeText(
        isStudent
            ? studentClass?.classSec.replaceAll('(Group Classes)', '').replaceAll('(Individual Classes)', '') ?? ''
            : teacherClass?.classSection.replaceAll('(Group Classes)', '').replaceAll('(Individual Classes)', '') ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 8,
        maxFontSize: 14,
        maxLines: 1,
      ),
    );
  }

  Widget _buildStartTime(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    return Expanded(
      flex: 3,
      child: AutoSizeText(
        isStudent
            ? studentClass?.startTime ?? ''
            : teacherClass?.startTime ?? '',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 10,
        maxFontSize: 14,
        maxLines: 1,
      ),
    );
  }
  
TodayClass ?isRescheduled;
bool isClicked=false;
TeacherClassDetail?selectedClass;
  Widget _buildJoinButton(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {
          if (isStudent && studentClass?.status == 'Join') {
            if (studentClass?.cancelOrRescheduleStatus != 'false') {
              googleMeet(studentClass?.rescheduleMeetLink ?? '');
            } else {
              googleMeet(studentClass?.meetLink ?? '');
            }
          } else if (!isStudent&& teacherClass?.status == 'Join') {
            if (teacherClass?.cancelOrRescheduleStatus != 'false') {
              googleMeet(teacherClass?.rescheduleMeetLink ?? '');
            } else {
              googleMeet(teacherClass?.meetLink ?? '');
            }
          } else if (isStudent && studentClass?.cancelOrRescheduleStatus != 'false' && studentClass?.status != 'Join') {
            setState(() {
              isRescheduled = studentClass;
              isClicked=!isClicked;
            });
          } else if (!isStudent&& teacherClass?.cancelOrRescheduleStatus != 'false' && teacherClass?.status != 'Join') {
            setState(() {
             selectedClass = teacherClass;
             isClicked=!isClicked;
            });
          }
        },
        child: Container(
         // width: screenWidth(100, context),
          height: 40,
          decoration: BoxDecoration(
            color: isStudent
                ? studentClass?.status == 'Join'
                    ? Utils.baseBlue
                    : Colors.white
                : teacherClass?.status == 'Join'
                    ? Utils.baseBlue
                    : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: SizedBox(
             // width: screenWidth(100, context),
              child: Center(
                child: AutoSizeText(
                  _getStatusText(isStudent, studentClass, teacherClass),
                  style: TextStyle(
                    color: _getStatusTextColor(isStudent, studentClass, teacherClass),
                    fontWeight: FontWeight.w600,
                  ),
                  minFontSize: 12,
                  maxFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRescheduledDetails(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Rescheduled Reason:',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isStudent
              ? studentClass?.rescheduleReason ?? ''
              : teacherClass?.rescheduleReason ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Rescheduled Date & Time:',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isStudent
              ? '${studentClass?.rescheduleDate} at ${studentClass?.rescheduleStart}'
              : '${teacherClass?.rescheduleDate} at ${teacherClass?.rescheduleStart}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getStatusText(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    if (isStudent) {
      if (studentClass?.status == 'Join') {
        return 'Join';
      } else if (studentClass?.cancelOrRescheduleStatus != 'false' && studentClass?.status != 'Join') {
        return studentClass?.cancelOrRescheduleStatus ?? '';
      } else {
        return studentClass?.status??'';
      }
    } else {
      if (teacherClass?.status == 'Join') {
        return 'Join';
      } else if (teacherClass?.cancelOrRescheduleStatus != 'false' && teacherClass?.status != 'Join') {
        return teacherClass?.cancelOrRescheduleStatus ?? '';
      } else {
        return teacherClass?.status??'';
      }
    }
  }

  Color _getStatusTextColor(bool isStudent, TodayClass? studentClass, TeacherClassDetail? teacherClass) {
    if (isStudent) {
      if (studentClass?.status == 'Join') {
        return Colors.white;
      } else if (studentClass?.cancelOrRescheduleStatus != 'false' && studentClass?.status != 'Join') {
        return Colors.red;
      } else {
        return Colors.black;
      }
    } else {
      if (teacherClass?.status == 'Join') {
        return Colors.white;
      } else if (teacherClass?.cancelOrRescheduleStatus != 'false' && teacherClass?.status != 'Join') {
        return Colors.red;
      } else {
        return Colors.black;
      }
    }
  }
}
