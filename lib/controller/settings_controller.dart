import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import '../screens/SplashScreen.dart';
import '../utils/Utils.dart';

class SettingsController extends GetxController {
  final Rx<String> _token = "".obs;
  final RxString _userId = ''.obs;

  Rx<String> get token => _token;

  Future deleteAccount(BuildContext context) async {
    await Utils.getStringValue('token').then((token) {
      _token.value = token ?? '';
    });

    await Utils.getStringValue('id').then((id) {
      _userId.value = id ?? '';
    });

    var headers = {
      'Authorization': _token.toString(),
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(InfixApi.accountDelete));
    request.fields.addAll({
      'id': _userId.toString(),
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Utils.showToast('User Deleted');
      Utils.clearAllValue();
      Get.offAll(const Splash());
      debugPrint('response ${await response.stream.bytesToString()}');
    } else {
      Utils.showToast('${response.reasonPhrase}');
      debugPrint('Error Response ${response.reasonPhrase}');
    }
  }
}

SettingsController settingsController = Get.put(SettingsController());
