import 'package:get/get.dart';

class SubjectAttendanceController extends GetxController {
  RxMap<String, SubjectAttendanceValue> attendanceMap =
      <String, SubjectAttendanceValue>{}.obs;
}

class SubjectAttendanceValue {
  SubjectAttendanceValue({
    this.student,
    this.attendanceClass,
    this.section,
    this.subject,
    this.attendanceType,
    this.note,
  });

  String? student;
  String? attendanceClass;
  String? section;
  String? subject;
  String? attendanceType;
  dynamic note;

  factory SubjectAttendanceValue.fromJson(Map<String, dynamic> json) =>
      SubjectAttendanceValue(
        student: json["student"].toString(),
        attendanceClass: json["class"].toString(),
        section: json["section"].toString(),
        subject: json["subject"].toString(),
        attendanceType: json["attendance_type"],
        note: json["note"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "student": student,
        "class": attendanceClass,
        "section": section,
        "subject": subject,
        "attendance_type": attendanceType,
        "note": note,
      };
}
