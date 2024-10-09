class RecordedClassListResponse {
  final bool success;
  final List<RecordedClass> recordedClasses;
  final String message;

  RecordedClassListResponse({
    required this.success,
    required this.recordedClasses,
    required this.message,
  });

  factory RecordedClassListResponse.fromJson(Map<String, dynamic> json) {
    return RecordedClassListResponse(
      success: json['success'],
      recordedClasses: (json['data']['recorded_classes'] as List)
          .map((e) => RecordedClass.fromJson(e))
          .toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': {
        'recorded_classes': recordedClasses.map((e) => e.toJson()).toList(),
      },
      'message': message,
    };
  }
}

class RecordedClass {
  final int id;
  final String className;
  final String dateOfClass;
  final String teacher;
  final String? onlineClassTopic;
  final String? dayOfWeek;
  final String? classTime;
  final String downloadPath;

  RecordedClass({
    required this.id,
    required this.className,
    required this.dateOfClass,
    required this.teacher,
    this.onlineClassTopic,
    this.dayOfWeek,
    this.classTime,
    required this.downloadPath,
  });

  factory RecordedClass.fromJson(Map<String, dynamic> json) {
    return RecordedClass(
      id: json['id'],
      className: json['class'],
      dateOfClass: json['date_of_class'],
      teacher: json['teacher'],
      onlineClassTopic: json['online_class_topic'],
      dayOfWeek: json['day_of_week'],
      classTime: json['class_time'],
      downloadPath: json['download_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class': className,
      'date_of_class': dateOfClass,
      'teacher': teacher,
      'online_class_topic': onlineClassTopic,
      'day_of_week': dayOfWeek,
      'class_time': classTime,
      'download_path': downloadPath,
    };
  }
}
