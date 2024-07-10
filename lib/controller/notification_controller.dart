// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/UserNotifications.dart';

class NotificationController extends GetxController {
  final Rx<String> _token = "".obs;

  Rx<String> get token => _token;

  final Rx<String> _id = "".obs;

  Rx<String> get id => _id;

  Rx<UserNotificationList> userNotificationList = UserNotificationList().obs;

  Rx<bool> isLoading = false.obs;

  Rx<int> notificationCount = 0.obs;

  Future<UserNotificationList> getNotifications() async {
  await getIdToken();
  try {
    isLoading(true);
    final response = await http.get(
      Uri.parse(EdusApi.getMyNotifications(_id)),
      headers: Utils.setHeader(_token.toString()),
    );

    

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      userNotificationList.value =
          UserNotificationList.fromJson(jsonData['data']);
      notificationCount.value = jsonData['data']['unread_notification'];
      isLoading(false);
      return userNotificationList.value!;
    } else {
      isLoading(false);
      throw Exception('Failed to load notifications');
    }
  } catch (e,t) {
    isLoading(false);
   
    throw Exception(e.toString());
  }
}
  Future readNotification() async {
    try{
 await getIdToken();
    var response = await http.post(
        Uri.parse(EdusApi.readMyNotifications(_id.value,0)),
        headers: Utils.setHeader(_token.toString()), body:jsonEncode({
        'id': 217
      }),);
       
        
    if (response.statusCode == 200) {
      Map notifications = jsonDecode(response.body) as Map;
      bool status = notifications['data']['status'] ?? false;
  
      return status;
    } else {
      debugPrint('Error retrieving from api');
    }
    }catch(e,t){
    debugPrint(e.toString());
     debugPrint(t.toString());
    }
   
  }

  Future getIdToken() async {
    await Utils.getStringValue('token').then((value) async {
      _token.value = value ?? '';
      await Utils.getStringValue('id').then((value) {
        _id.value = value ?? '';
      });
    });
  }

  @override
  void onInit() {
    getNotifications();

    super.onInit();
  }
}
