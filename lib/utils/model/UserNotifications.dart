class UserNotifications {
  UserNotifications({
    this.id,
    this.date,
    this.message,
    this.url,
    this.createdAt,
    this.isRead,
  });

  dynamic id;
  DateTime? date;
  String? message;
  String? url;
  DateTime? createdAt;
  String? isRead;

  factory UserNotifications.fromJson(Map<String, dynamic> json) => UserNotifications(
    id: json["id"],
    date: json["date"] != null ? DateTime.parse(json["date"]) : null,
    message: json["message"],
    url: json["url"],
    createdAt: DateTime.parse(json["created_at"]),
    isRead: json["is_read"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date != null ? "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}" : null,
    "message": message,
    "url": url,
    "created_at": createdAt?.toIso8601String(),
    "is_read": isRead,
  };
}

class UserNotificationList {
  List<UserNotifications>? userNotifications;

  UserNotificationList({this.userNotifications});

  factory UserNotificationList.fromJson(Map<String, dynamic> json) {
    List<UserNotifications> notifications = [];
    if (json['notifications'] != null) {
      notifications = List<UserNotifications>.from(
        json['notifications'].map((x) => UserNotifications.fromJson(x))
      );
    }
    return UserNotificationList(userNotifications: notifications);
  }
}
