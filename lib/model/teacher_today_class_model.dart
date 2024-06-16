class TeacherTodayClassResponse {
  final bool success;
  final TodayClassData data;
  final String message;

  TeacherTodayClassResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TeacherTodayClassResponse.fromJson(Map<String, dynamic> json) {
    return TeacherTodayClassResponse(
      success: json['success'],
      data: TodayClassData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class TodayClassData {
  final List<TeacherClassDetail> todayClass;

  TodayClassData({
    required this.todayClass,
  });

  factory TodayClassData.fromJson(Map<String, dynamic> json) {
    return TodayClassData(
      todayClass: List<TeacherClassDetail>.from(json['today_class'].map((classJson) => TeacherClassDetail.fromJson(classJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today_class': todayClass.map((classDetail) => classDetail.toJson()).toList(),
    };
  }
}

class TeacherClassDetail {
  final String cancelOrRescheduleStatus;
  final String startTime;
  final String endTime;
  final String topic;
  final String classSection;
  final String status;
  final String meetLink;
  final String type;
  final String? dateOfClass;
  final String? rescheduleDate;
  final String? rescheduleTeacher;
  final String? rescheduleStart;
  final String? rescheduleEnd;
  final String? rescheduleMeetLink;
  final String? rescheduleReason;

  TeacherClassDetail({
    required this.cancelOrRescheduleStatus,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.classSection,
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

  factory TeacherClassDetail.fromJson(Map<String, dynamic> json) {
    return TeacherClassDetail(
      cancelOrRescheduleStatus: json['cancel_or_reschedule_status'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      topic: json['topic'],
      classSection: json['class_sec'],
      status: json['status'],
      meetLink: json['meet_link'],
      type: json['type'],
      dateOfClass: json['date_of_class'],
      rescheduleDate: json['reschedule_date'],
      rescheduleTeacher: json['reschedule_teacher'],
      rescheduleStart: json['reschedule_start'],
      rescheduleEnd: json['reschedule_end'],
      rescheduleMeetLink: json['reschedule_meet_link'],
      rescheduleReason: json['reschedule_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cancel_or_reschedule_status': cancelOrRescheduleStatus,
      'start_time': startTime,
      'end_time': endTime,
      'topic': topic,
      'class_sec': classSection,
      'status': status,
      'meet_link': meetLink,
      'type': type,
      'date_of_class': dateOfClass,
      'reschedule_date': rescheduleDate,
      'reschedule_teacher': rescheduleTeacher,
      'reschedule_start': rescheduleStart,
      'reschedule_end': rescheduleEnd,
      'reschedule_meet_link': rescheduleMeetLink,
      'reschedule_reason': rescheduleReason,
    };
  }
}
