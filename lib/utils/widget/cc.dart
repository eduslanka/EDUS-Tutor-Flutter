import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/widget/snack_bars.dart';

import '../../controller/exceptions/conflict_exception.dart';
import '../../controller/exceptions/default.exception.dart';
import '../../controller/exceptions/forbidden.exception.dart';
import '../../controller/exceptions/unprocessable_exception.dart';

class CustomController extends GetxController {
  var isLoading = false.obs;
  var errorMsg = "".obs;
  var connected = false.obs;
  var connectedStatus = false.obs;
  var serverMessage = ''.obs;

  Future loadData() async {
    try {
      isLoading(true);

      final response = await http.get(Uri.parse(InfixApi.service),
          headers: {'Accept': 'application/json'});
      print('Service Check Response::::::: ${response.statusCode}');
      var decode = jsonDecode(response.body);
      print('Service Check Response::::::: ${response.body}');

      if (response.statusCode == 200) {
        isLoading(false);
        connected.value = decode;
        return connected.value;
      } else {
        connectedStatus.value = true;
        serverMessage.value = decode['message'];
      }
    } on UnProcessableException catch (e) {
      showBasicFailedSnackBar(message: e.message);
    } on ForbiddenException catch (e) {
      showBasicFailedSnackBar(message: e.message);
    } on ConflictException catch (e) {
      showBasicFailedSnackBar(message: e.message);
    } on DefaultException catch (e) {
      showBasicFailedSnackBar(message: e.message);
    } catch (e, t) {
      print('$e');
      print('$t');
      connectedStatus.value = true;
      serverMessage.value = 'Something Went wrong.\n Restart your app.';
      isLoading(false);
      errorMsg.value = e.toString();
      throw e.toString();
    } finally {
      isLoading(false);
    }

    // try {
    //   isLoading(true);
    //
    //   final response = await http.get(Uri.parse(InfixApi.service),
    //       headers: {'Accept': 'application/json'});
    //   print('Service Check Response::::::: ${response.statusCode}');
    //   var decode = jsonDecode(response.body);
    //   isLoading(false);
    //   connected.value = decode;
    //   return connected.value;
    //
    // } catch (e, t) {
    //   print('$e');
    //   print('$t');
    //   isLoading(false);
    //   errorMsg.value = e.toString();
    //   throw e.toString();
    // } finally {
    //   isLoading(false);
    // }
  }

  @override
  void onInit() {
    loadData();
    super.onInit();
  }
}

