// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/UserNotifications.dart';

class NotificationProvider extends ChangeNotifier{

  String id = '';
  String token = '';

  Future<UserNotificationList> getNotification(id,token) async{
    Utils.getStringValue('token').then((value) {
      token = value;
    });
    final response = await http.get(Uri.parse(InfixApi.getMyNotifications(id)),headers: Utils.setHeader(token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return UserNotificationList.fromJson(jsonData['data']['notifications']);
    } else {
      throw Exception('failed to load');
    }
  }
}
