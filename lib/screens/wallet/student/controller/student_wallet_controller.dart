import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/controller/user_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:edus_tutor/screens/wallet/student/model/Wallet.dart';
import 'package:edus_tutor/utils/CustomSnackBars.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:http/http.dart' as http;

class StudentWalletController extends GetxController {
  RxBool isWalletLoading = false.obs;

  final UserController userController = Get.put(UserController());

  Rx<Wallet> wallet = Wallet().obs;

  Rx<String> selectedPaymentMethod = "Select Payment Method".tr.obs;

  Rx<BankAccount> selectedBank = BankAccount().obs;

  Rx<bool> isCheque = false.obs;

  Rx<bool> isBank = false.obs;

  Rx<bool> isPaymentProcessing = false.obs;

  final dio.Dio _dio = dio.Dio();

  TextEditingController paymentNoteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Rx<File> file = File("").obs;

  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      file.value = File(result.files.single.path ?? '');
    } else {
      Utils.showToast('Cancelled');
    }
  }

  Future<Wallet> getMyWallet() async {
    print("Wallet call");
    isWalletLoading(true);
    print('loading :: ${isWalletLoading.value}');
    try {
      final response = await http.get(
        Uri.parse(EdusApi.studentWallet),
        headers: Utils.setHeader(
          userController.token.value.toString(),
        ),
      );

      if (response.statusCode == 200) {
        var data = walletFromJson(response.body);

        isWalletLoading(false);
        print('loading :: ${isWalletLoading.value}');
        wallet.value = data;

        if (wallet.value.bankAccounts!.isNotEmpty) {
          selectedBank.value = wallet.value.bankAccounts!.first;
        }

        wallet.value.paymentMethods
            ?.insert(0, PaymentMethod(method: "Select Payment Method".tr));

        selectedPaymentMethod.value =
            wallet.value.paymentMethods?.first.method ?? '';
      } else {
        throw Exception('Failed to load post');
      }
      return wallet.value;
    } catch (e, t) {
      isWalletLoading(false);
      print('loading :: error ${isWalletLoading.value}');
      print(e);
      print(t);
      throw Exception(e.toString());
    }
  }

  void chequeBankOrOthers() {
    isCheque.value = false;
    isBank.value = false;
    if (selectedPaymentMethod.value == "Cheque") {
      isCheque.value = true;
    } else if (selectedPaymentMethod.value == "Bank") {
      isBank.value = true;
    } else {
      isCheque.value = false;
      isBank.value = false;
    }
  }

  Future submitPayment({File? file, BuildContext? context}) async {
    if (selectedPaymentMethod.value == "Select Payment Method".tr) {
      CustomSnackBar().snackBarWarning("Select a Payment method first!".tr);
    } else {
      final paymentData = dio.FormData.fromMap({
        "amount": amountController.value.text,
        "payment_method": selectedPaymentMethod.value,
        "file":
            file != null ? await dio.MultipartFile.fromFile(file.path) : null,
        "note": paymentNoteController.value.text,
        if (selectedPaymentMethod.value == "Bank")
          "bank":
              "${selectedBank.value.bankName} (${selectedBank.value.accountNumber})",
      });

      await processPayment(paymentData);
    }
  }

  Future processPayment(dio.FormData formData, {BuildContext? context}) async {
    log(formData.fields.toString());
    try {
      isPaymentProcessing(true);
      await _dio
          .post(EdusApi.addToWallet,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        if (value.statusCode == 200) {
          isPaymentProcessing(false);

          await getMyWallet();
          CustomSnackBar().snackBarSuccess("Payment Added".tr);
          Future.delayed(const Duration(seconds: 4), () {
            Get.back();
          });
        } else {
          log("Error: ${value.data}");
        }
      }).catchError((error) {
        if (error is dio.DioError) {
          isPaymentProcessing(false);
          final errorData = Map<String, dynamic>.from(error.response?.data);
          String combinedMessage = "";
          errorData["errors"].forEach((key, messages) {
            for (var message in messages) {
              combinedMessage = combinedMessage + "$message\n";
            }
          });
          CustomSnackBar().snackBarError(combinedMessage);
        }
      });
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    } finally {
      isPaymentProcessing(false);
    }
  }

  Future confirmWalletPayment({String? id, dynamic amount}) async {
    Get.back();
    final formData = dio.FormData.fromMap({
      "id": id,
      "amount": amount,
    });

    try {
      isPaymentProcessing(true);
      await _dio
          .post(EdusApi.confirmWalletPayment,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        log(value.statusCode.toString());
        await getMyWallet();
        isPaymentProcessing(false);
      }).catchError((error) {
        isPaymentProcessing(false);
        if (error is dio.DioError) {
          final errorData = Map<String, dynamic>.from(error.response?.data);
          String combinedMessage = "";
          errorData["errors"].forEach((key, messages) {
            for (var message in messages) {
              combinedMessage = combinedMessage + "$message\n";
            }
          });
          CustomSnackBar().snackBarError(combinedMessage);
        }
      });
    } catch (e, t) {
      debugPrint(e.toString());
      debugPrint(t.toString());
    } finally {
      isPaymentProcessing(false);
    }
  }

  Future getUserData() async {
    await Utils.getStringValue('email').then((emailValue) {
      _email.value = emailValue ?? '';
    });
    await Utils.getStringValue('id').then((idValue) {
      _id.value = idValue ?? '';
    });
    await Utils.getStringValue('phone').then((phoneValue) {
      _phone.value = phoneValue ?? '';
    });
  }

  @override
  void onInit() {
    getUserData();
    getMyWallet();
    super.onInit();
  }

  final Rx<String> _email = "".obs;
  Rx<String> get email => _email;

  final Rx<String> _id = "".obs;
  Rx<String> get id => _id;

  final Rx<String> _phone = "".obs;
  Rx<String> get phone => _phone;
}
