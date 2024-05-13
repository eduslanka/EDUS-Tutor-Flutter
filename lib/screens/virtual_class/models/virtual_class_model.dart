// To parse this JSON data, do
//
//     final bbbVirtualClass = bbbVirtualClassFromJson(jsonString);

import 'dart:convert';

VirtualClass bbbVirtualClassFromJson(String str) =>
    VirtualClass.fromJson(json.decode(str));

String bbbVirtualClassToJson(VirtualClass data) => json.encode(data.toJson());

class VirtualClass {
  VirtualClass({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  VirtualClassData? data;
  dynamic message;

  factory VirtualClass.fromJson(Map<String, dynamic> json) => VirtualClass(
        success: json["success"],
        data: VirtualClassData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class VirtualClassData {
  VirtualClassData({
    this.meetings,
  });

  List<Meeting>? meetings;

  factory VirtualClassData.fromJson(Map<String, dynamic> json) =>
      VirtualClassData(
        meetings: List<Meeting>.from(
            json["meetings"].map((x) => Meeting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meetings": List<dynamic>.from(meetings?.map((x) => x.toJson()) ?? []),
      };
}

class Meeting {
  Meeting({
    this.id,
    this.createdBy,
    this.meetingId,
    this.startTime,
    this.endTime,
    this.classId,
    this.sectionId,
    this.subjectId,
    this.topic,
    this.description,
    this.attendeePassword,
    this.moderatorPassword,
    this.date,
    this.time,
    this.datetime,
    this.timeStartBefore,
    this.welcomeMessage,
    this.maxParticipants,
    this.logoutUrl,
    this.record,
    this.duration,
    this.meetingDuration,
    this.logo,
    this.status,
  });

  int? id;
  int? createdBy;
  String? meetingId;
  DateTime? startTime;
  DateTime? endTime;
  int? classId;
  String? sectionId;
  dynamic subjectId;
  String? topic;
  String? description;
  String? attendeePassword;
  String? moderatorPassword;
  String? date;
  String? time;
  String? datetime;
  String? timeStartBefore;
  dynamic welcomeMessage;
  int? maxParticipants;
  dynamic logoutUrl;
  int? record;
  int? duration;
  String? meetingDuration;
  String? logo;
  String? status;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        id: json["id"],
        createdBy: json["created_by"],
        meetingId: json["meeting_id"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        topic: json["topic"],
        description: json["description"],
        attendeePassword: json["attendee_password"],
        moderatorPassword: json["moderator_password"],
        date: json["date"],
        time: json["time"],
        datetime: json["datetime"],
        timeStartBefore: json["time_start_before"],
        welcomeMessage: json["welcome_message"],
        maxParticipants: json["max_participants"],
        logoutUrl: json["logout_url"],
        duration: json["duration"],
        meetingDuration:
            json["meeting_duration"],
        logo: json["logo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "meeting_id": meetingId,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "class_id": classId,
        "section_id": sectionId,
        "subject_id": subjectId,
        "topic": topic,
        "description": description,
        "attendee_password": attendeePassword,
        "moderator_password": moderatorPassword,
        "date": date,
        "time": time,
        "datetime": datetime,
        "time_start_before": timeStartBefore,
        "welcome_message": welcomeMessage,
        "max_participants": maxParticipants,
        "logout_url": logoutUrl,
        "record": record,
        "duration": duration,
        "meeting_duration": meetingDuration,
        "logo": logo,
        "status": status,
      };
}
