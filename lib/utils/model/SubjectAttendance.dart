class SubjectAttendance {
  dynamic id;
  dynamic recordId;
  dynamic uid;
  dynamic sId;
  String? photo;
  String? name;
  dynamic roll;
  dynamic classId;
  dynamic sectionId;
  dynamic subjectId;
  String? className;
  String? sectionName;
  String? subjectName;
  String? attendanceType;

  SubjectAttendance({
    this.id,
    this.recordId,
    this.sId,
    this.photo,
    this.name,
    this.roll,
    this.classId,
    this.sectionId,
    this.subjectId,
    this.className,
    this.sectionName,
    this.subjectName,
    this.attendanceType,
    this.uid,
  });

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) {
    return SubjectAttendance(
      id: json['id'],
      recordId: json['record_id'],
      sId: json['student_id'],
      photo: json['student_photo'],
      name: json['full_name'],
      roll: json['roll_no'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      subjectId: json['subject_id'],
      className: json['class_name'],
      sectionName: json['section_name'],
      subjectName: json['subject_name'],
      attendanceType: json['attendance_type'],
      uid: json['user_id'],
    );
  }
}

class SubjectAttendanceList {
  List<SubjectAttendance> attendances;

  SubjectAttendanceList(this.attendances);

  factory SubjectAttendanceList.fromJson(List<dynamic> json) {
    List<SubjectAttendance> attendanceList = [];

    attendanceList = json.map((i) => SubjectAttendance.fromJson(i)).toList();

    return SubjectAttendanceList(attendanceList);
  }
}
