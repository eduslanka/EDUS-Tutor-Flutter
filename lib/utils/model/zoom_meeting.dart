class ZoomMeeting {
  // ignore: prefer_typing_uninitialized_variables
  final id;
  // ignore: prefer_typing_uninitialized_variables
  final meetingId;
  // ignore: prefer_typing_uninitialized_variables
  final password;
  // ignore: prefer_typing_uninitialized_variables
  final startDate;
  // ignore: prefer_typing_uninitialized_variables
  final startTime;
  // ignore: prefer_typing_uninitialized_variables
  DateTime? endTime;
  // ignore: prefer_typing_uninitialized_variables
  final topic;
  // ignore: prefer_typing_uninitialized_variables
  final description;

  ZoomMeeting(
      {this.id,
      this.password,
      this.startTime,
      this.endTime,
      this.topic,
      this.description,
      this.meetingId,
      this.startDate});

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) {
    return ZoomMeeting(
      id: json['id'],
      password: json['password'],
      meetingId: json['meeting_id'],
      startTime: json['time_of_meeting'],
      endTime: DateTime.parse(json["end_time"]),
      startDate: json['date_of_meeting'],
      description: json['description'],
      topic: json['topic'],
    );
  }
}

class ZoomMeetingList {
  final List<ZoomMeeting>? meetings;

  ZoomMeetingList({this.meetings});

  factory ZoomMeetingList.fromJson(List<dynamic> json) {
    List<ZoomMeeting> meetingList = [];
    meetingList = json.map((e) => ZoomMeeting.fromJson(e)).toList();
    return ZoomMeetingList(meetings: meetingList);
  }
}
