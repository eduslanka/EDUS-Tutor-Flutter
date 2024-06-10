import 'package:intl/intl.dart';


class TodayClass {
  final String cancelOrRescheduleStatus;
  final String classSec;
  final String startTime;
  final String endTime;
  final String topic;
  final String teacher;
  final String status;
  final String meetLink;
  final String? rescheduleDate;
  final String? rescheduleTeacher;
  final String? rescheduleStart;
  final String? rescheduleEnd;
  final String? rescheduleMeetLink;
  final String? rescheduleReason;

  TodayClass({
    required this.cancelOrRescheduleStatus,
    required this.classSec,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.teacher,
    required this.status,
    required this.meetLink,
    this.rescheduleDate,
    this.rescheduleTeacher,
    this.rescheduleStart,
    this.rescheduleEnd,
    this.rescheduleMeetLink,
    this.rescheduleReason,
  });

  factory TodayClass.fromJson(Map<String, dynamic> json) {
    return TodayClass(
      cancelOrRescheduleStatus: json['cancel_or_reschedule_status'] ?? '',
      classSec: json['class_sec'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      topic: json['topic'] ?? '',
      teacher: json['teacher'] ?? '',
      status: json['status'] ?? '',
      meetLink: json['meet_link'] ?? '',
      rescheduleDate: json['reschedule_date'],
      rescheduleTeacher: json['reschedule_teacher'],
      rescheduleStart: json['reschedule_start'],
      rescheduleEnd: json['reschedule_end'],
      rescheduleMeetLink: json['reschedule_meet_link'],
      rescheduleReason: json['reschedule_reason'],
    );
  }
}

class TodayClassResponse {
  final bool success;
  final List<TodayClass> classes;

  TodayClassResponse({required this.success, required this.classes});

  factory TodayClassResponse.fromJson(Map<String, dynamic> json) {
  final now = DateTime.now();
  final dayName = DateFormat('EEEE').format(now);
  print(dayName);
    var classesJson =json['data']['today_class'] !=[]? json['data']['today_class'] as List:[] ;
    List<TodayClass> classesList =
        classesJson.map((i) => TodayClass.fromJson(i)).toList();

    return TodayClassResponse(success: json['success'] , classes: classesList);
  }
}

