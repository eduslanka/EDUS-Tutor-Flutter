import 'package:flutter/material.dart';
import 'package:infixedu/screens/chat/models/ChatActiveStatus.dart';
import 'package:infixedu/screens/chat/models/ChatRoles.dart';

class ChatUser {
  ChatUser({
    this.id,
    this.fullName,
    this.username,
    this.email,
    this.firstName,
    this.avatarUrl,
    this.blockedByMe,
    this.block,
    this.lastMessage,
    this.roles,
    this.activeStatus,
  });

  int? id;
  String? fullName;
  String? username;
  String? email;
  String? firstName;
  String? avatarUrl;
  bool? blockedByMe;
  bool? block;
  String? lastMessage;
  ChatRoles? roles;
  dynamic activeStatus;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        id: int.parse(json["id"].toString()),
        fullName: json["full_name"],
        username: json["username"],
        email: json["email"],
        firstName: json["first_name"],
        avatarUrl: json["avatar_url"] == null || json["avatar_url"] == ""
            ? null
            : json["avatar_url"],
        blockedByMe:
            json["blocked_by_me"],
        block: json["blocked"] ?? false,
        lastMessage: json["last_message"],
        roles: json["roles"] == null ? null : ChatRoles.fromJson(json["roles"]),
        activeStatus: json["active_status"] == null
            ? null
            : json["active_status"] is int || json["active_status"] is String
                ? json["active_status"]
                : ChatActiveStatus.fromJson(json["active_status"]).status,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "username": username,
        "email": email,
        "first_name": firstName,
        "avatar_url": avatarUrl,
        "blocked_by_me": blockedByMe,
        "block": block,
        "last_message": lastMessage,
        "roles": roles == null ? null : roles?.toJson(),
        "active_status": activeStatus,
      };

  getOnlineColor(dynamic status) {
    if (status == 0) {
      return Colors.transparent;
    } else if (status == 1) {
      return Colors.green;
    } else if (status == 2) {
      return Colors.amber;
    } else if (status == 3) {
      return Colors.red;
    }
  }
}
