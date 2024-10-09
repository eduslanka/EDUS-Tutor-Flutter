class WeeklyClassResponse {
  final bool success;
  final WeeklyClassData data;
  final String message;

  WeeklyClassResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory WeeklyClassResponse.fromJson(Map<String, dynamic> json) {
    return WeeklyClassResponse(
      success: json['success'],
      data: WeeklyClassData.fromJson(json['data']),
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

class WeeklyClassData {
  final Map<String, List<ClassDetail>> weeklyClass;

  WeeklyClassData({
    required this.weeklyClass,
  });

  factory WeeklyClassData.fromJson(Map<String, dynamic> json) {
    Map<String, List<ClassDetail>> weeklyClassMap = {};
    if (json['weekly_class'] != null && json['weekly_class'] is List) {
      json['weekly_class'].forEach((element) {
        element.forEach((day, classes) {
          List<ClassDetail> classList = [];
          if (classes is List) {
            for (var classJson in classes) {
              classList.add(ClassDetail.fromJson(classJson));
            }
          }
          weeklyClassMap[day] = classList;
        });
      });
    }
    return WeeklyClassData(weeklyClass: weeklyClassMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> weeklyClassMap = {};
    weeklyClass.forEach((day, classes) {
      weeklyClassMap[day] =
          classes.map((classDetail) => classDetail.toJson()).toList();
    });
    return {
      'weekly_class': [weeklyClassMap],
    };
  }
}

class ClassDetail {
  final dynamic cancelOrRescheduleStatus;
  final dynamic startTime;
  final dynamic endTime;
  final dynamic topic;
  final dynamic classSection;
  final dynamic teacher;
  final dynamic status;
  final dynamic meetLink;
  final String? rescheduleDate;
  final String? rescheduleTeacher;
  final String? rescheduleStart;
  final String? rescheduleEnd;
  final String? rescheduleMeetLink;
  final String? rescheduleReason;

  ClassDetail({
    required this.cancelOrRescheduleStatus,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.classSection,
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

  factory ClassDetail.fromJson(Map<String, dynamic> json) {
    return ClassDetail(
      cancelOrRescheduleStatus: json['cancel_or_reschedule_status'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      topic: json['topic'],
      classSection: json['class_sec'],
      teacher: json['teacher'],
      status: json['status'],
      meetLink: json['meet_link'],
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
      'teacher': teacher,
      'status': status,
      'meet_link': meetLink,
      'reschedule_date': rescheduleDate,
      'reschedule_teacher': rescheduleTeacher,
      'reschedule_start': rescheduleStart,
      'reschedule_end': rescheduleEnd,
      'reschedule_meet_link': rescheduleMeetLink,
      'reschedule_reason': rescheduleReason,
    };
  }
}
