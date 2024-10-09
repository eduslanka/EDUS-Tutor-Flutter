class TeacherWeeklyClassResponse {
  final bool success;
  final TeacherWeeklyClassData data;
  final String message;

  TeacherWeeklyClassResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TeacherWeeklyClassResponse.fromJson(Map<String, dynamic> json) {
    return TeacherWeeklyClassResponse(
      success: json['success'],
      data: TeacherWeeklyClassData.fromJson(json['data']),
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

class TeacherWeeklyClassData {
  final Map<String, List<TeachersClassDetail>> weeklyClass;

  TeacherWeeklyClassData({
    required this.weeklyClass,
  });

  factory TeacherWeeklyClassData.fromJson(Map<String, dynamic> json) {
    Map<String, List<TeachersClassDetail>> weeklyClassMap = {};
    if (json['weekly_class'] != null) {
      json['weekly_class'][0].forEach((day, classes) {
        List<TeachersClassDetail> classList = [];
        if (classes is List) {
          for (var classJson in classes) {
            classList.add(TeachersClassDetail.fromJson(classJson));
          }
        }
        weeklyClassMap[day] = classList;
      });
    }
    return TeacherWeeklyClassData(weeklyClass: weeklyClassMap);
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

class TeachersClassDetail {
  final dynamic cancelOrRescheduleStatus;
  final String startTime;
  final String endTime;
  final String topic;
  final String classSection;
  final String status;
  final String meetLink;
  final String? rescheduleDate;
  final String? rescheduleStart;
  final String? rescheduleEnd;
  final String? rescheduleMeetLink;
  final String? rescheduleReason;

  TeachersClassDetail({
    required this.cancelOrRescheduleStatus,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.classSection,
    required this.status,
    required this.meetLink,
    this.rescheduleDate,
    this.rescheduleStart,
    this.rescheduleEnd,
    this.rescheduleMeetLink,
    this.rescheduleReason,
  });

  factory TeachersClassDetail.fromJson(Map<String, dynamic> json) {
    return TeachersClassDetail(
      cancelOrRescheduleStatus: json['cancel_or_reschedule_status'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      topic: json['topic'],
      classSection: json['class_sec'],
      status: json['status'],
      meetLink: json['meet_link'],
      rescheduleDate: json['reschedule_date'],
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
      'reschedule_date': rescheduleDate,
      'reschedule_start': rescheduleStart,
      'reschedule_end': rescheduleEnd,
      'reschedule_meet_link': rescheduleMeetLink,
      'reschedule_reason': rescheduleReason,
    };
  }
}
