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
  final Map<String, List<ClassDetails>> weeklyClass;

  WeeklyClassData({
    required this.weeklyClass,
  });

  factory WeeklyClassData.fromJson(Map<String, dynamic> json) {
    Map<String, List<ClassDetails>> weeklyClassMap = {};
    json['weekly_class'].forEach((day, classes) {
      List<ClassDetails> classList = [];
      classes.forEach((classJson) {
        classList.add(ClassDetails.fromJson(classJson));
      });
      weeklyClassMap[day] = classList;
    });
    return WeeklyClassData(weeklyClass: weeklyClassMap);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> weeklyClassMap = {};
    weeklyClass.forEach((day, classes) {
      weeklyClassMap[day] = classes.map((classDetail) => classDetail.toJson()).toList();
    });
    return {
      'weekly_class': weeklyClassMap,
    };
  }
}

class ClassDetails {
  final String cancelOrRescheduleStatus;
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

  ClassDetails({
    required this.cancelOrRescheduleStatus,
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

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      cancelOrRescheduleStatus: json['cancel_or_reschedule_status'] ,
      startTime: json['start_time'],
      endTime: json['end_time'],
      topic: json['topic'],
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
