import 'dart:convert';

import 'package:intl/intl.dart';

// Function to convert JSON to TeacherTodayClassResponse
TeacherTodayClassResponse teacherTodayClassResponseFromJson(String str) => TeacherTodayClassResponse.fromJson(json.decode(str));


class TeacherTodayClassResponse {
  final bool success;
  final List<ClassInfo> classes;

  TeacherTodayClassResponse({required this.success, required this.classes});

  factory TeacherTodayClassResponse.fromJson(Map<String, dynamic> json) {
  final now = DateTime.now();
  final dayName = DateFormat('EEEE').format(now);
  print(dayName);
    var classesJson =json['data']['today_class'] != null ||json['data']['today_class'] !=[]? json['data']['today_class'][dayName] as List:[] ;
    List<ClassInfo> classesList =
        classesJson.map((i) => ClassInfo.fromJson(i)).toList();

    return TeacherTodayClassResponse(success: json['success'] , classes: classesList);
  }
  
 
}




class ClassInfo {
  ClassInfo({
    required this.cancelOrRescheduleStatus,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.classSec,
    required this.status,
    required this.meetLink,
    required this.type,
    this.dateOfClass,
    this.rescheduleDate,
    this.rescheduleTeacher,
    this.rescheduleStart,
    this.rescheduleEnd,
    this.rescheduleMeetLink,
    this.rescheduleReason,
  });

  String cancelOrRescheduleStatus;
  String startTime;
  String endTime;
  String topic;
  String classSec;
  String status;
  String meetLink;
  String type;
  String? dateOfClass;
  String? rescheduleDate;
  String? rescheduleTeacher;
  String? rescheduleStart;
  String? rescheduleEnd;
  String? rescheduleMeetLink;
  String? rescheduleReason;

  factory ClassInfo.fromJson(Map<String, dynamic> json) => ClassInfo(
    cancelOrRescheduleStatus: json["cancel_or_reschedule_status"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    topic: json["topic"],
    classSec: json["class_sec"],
    status: json["status"],
    meetLink: json["meet_link"],
    type: json["type"],
    dateOfClass: json["date_of_class"],
    rescheduleDate: json["reschedule_date"],
    rescheduleTeacher: json["reschedule_teacher"],
    rescheduleStart: json["reschedule_start"],
    rescheduleEnd: json["reschedule_end"],
    rescheduleMeetLink: json["reschedule_meet_link"],
    rescheduleReason: json["reschedule_reason"],
  );

  Map<String, dynamic> toJson() => {
    "cancel_or_reschedule_status": cancelOrRescheduleStatus,
    "start_time": startTime,
    "end_time": endTime,
    "topic": topic,
    "class_sec": classSec,
    "status": status,
    "meet_link": meetLink,
    "type": type,
    "date_of_class": dateOfClass,
    "reschedule_date": rescheduleDate,
    "reschedule_teacher": rescheduleTeacher,
    "reschedule_start": rescheduleStart,
    "reschedule_end": rescheduleEnd,
    "reschedule_meet_link": rescheduleMeetLink,
    "reschedule_reason": rescheduleReason,
  };
}
