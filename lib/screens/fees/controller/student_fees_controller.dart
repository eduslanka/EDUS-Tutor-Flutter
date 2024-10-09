import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/controller/user_controller.dart';
import 'package:edus_tutor/screens/fees/paymentGateway/RazorPay/razorpay_service.dart';
import 'package:edus_tutor/utils/CustomSnackBars.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/screens/fees/model/StudentAddPaymentModel.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../../../model/fee_invoice_model.dart';

class StudentFeesController extends GetxController {
  final UserController userController = Get.put(UserController());

  Rx<List<ClassRecord>> feesRecordList = Rx<List<ClassRecord>>([]);
  Rx<ClassRecord> feesRecord = ClassRecord().obs;

  Rx<bool> isFeesLoading = false.obs;

  Rx<bool> isLoading = false.obs;

  Rx<StudentAddPaymentModel> addPaymentModel = StudentAddPaymentModel().obs;

  Rx<double> addInWallet = 0.0.obs;

  var addWalletList = [].obs;

  var amountList = [].obs;

  var paidAmountList = [].obs;

  var dueList = [].obs;

  Rx<double> totalPaidAmount = 0.0.obs;

  var noteList = [].obs;

  var feeTypeList = [].obs;

  Rx<String> selectedPaymentMethod = "Select Payment Method".tr.obs;

  Rx<BankAccount> selectedBank = BankAccount().obs;

  Rx<bool> isCheque = false.obs;

  Rx<bool> isBank = false.obs;

  Rx<bool> isPaymentProcessing = false.obs;

  final dio.Dio _dio = dio.Dio();

  TextEditingController paymentNoteController = TextEditingController();

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
      if (selectedPaymentMethod.value == "Cheque") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": addPaymentModel
              .value.invoiceInfo?.studentInfo?.user?.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "payment_note": paymentNoteController.text,
          "file": await dio.MultipartFile.fromFile(file?.path ?? ''),
          "invoice_id": addPaymentModel.value.invoiceInfo?.id,
          "student_id": addPaymentModel.value.invoiceInfo?.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Bank") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": addPaymentModel
              .value.invoiceInfo?.studentInfo?.user?.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "bank": "${selectedBank.value.id}",
          "payment_note": paymentNoteController.text,
          "file": await dio.MultipartFile.fromFile(file?.path ?? ''),
          "invoice_id": addPaymentModel.value.invoiceInfo?.id,
          "student_id": addPaymentModel.value.invoiceInfo?.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });
        await processPayment(paymentData);
      } else if (selectedPaymentMethod.value == "Wallet") {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": addPaymentModel
              .value.invoiceInfo?.studentInfo?.user?.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "invoice_id": addPaymentModel.value.invoiceInfo?.id,
          "student_id": addPaymentModel.value.invoiceInfo?.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });

        await processPayment(paymentData);
      } else {
        final paymentData = dio.FormData.fromMap({
          "wallet_balance": addPaymentModel
              .value.invoiceInfo?.studentInfo?.user?.walletBalance,
          "add_wallet": addWalletList.reduce((a, b) => a + b),
          "payment_method": selectedPaymentMethod.value,
          "invoice_id": addPaymentModel.value.invoiceInfo?.id,
          "student_id": addPaymentModel.value.invoiceInfo?.recordId,
          "fees_type[]": feeTypeList,
          "amount[]": amountList,
          "due[]": dueList,
          "extraAmount[]": addWalletList,
          "paid_amount[]": paidAmountList,
          "note[]": noteList,
          "total_paid_amount": totalPaidAmount.value
        });

        await processPayment(paymentData);
      }
    }
  }

  Future processPayment(dio.FormData formData, {BuildContext? context}) async {
    log(formData.fields.toString());
    // return;
    try {
      isPaymentProcessing(true);
      Map<String, dynamic> data;
      await _dio
          .post(EdusApi.studentPaymentStore,
              data: formData,
              options: dio.Options(
                headers: Utils.setHeader(userController.token.value.toString()),
              ))
          .then((value) async {
        log(value.toString());
        if (value.statusCode == 200) {
          if (selectedPaymentMethod.value == "Wallet" ||
              selectedPaymentMethod.value == "Cheque" ||
              selectedPaymentMethod.value == "Bank") {
            isPaymentProcessing(false);
            await fetchFeesRecord(userController.studentId.value,
                userController.studentRecord.value.records?.first.id);
            Get.back();
            CustomSnackBar().snackBarSuccess("Payment Added".tr);
          } else {
            data = Map<String, dynamic>.from(value.data);
          }
        } else {
          data = Map<String, dynamic>.from(value.data);
          log(data.toString());
        }
      }).catchError((error) {
        if (error is dio.DioException) {
          isPaymentProcessing(false);

          final errorData = Map<String, dynamic>.from(error.response?.data);

          String combinedMessage = "";

          errorData["errors"].forEach((key, messages) {
            for (var message in messages) {
              combinedMessage = "$combinedMessage$message\n";
            }
          });
          CustomSnackBar().snackBarError(combinedMessage);
        }
      });
    } finally {}
  }

  Future confirmPaymentCallBack(String transactionId) async {
    try {
      Map<String, dynamic> data;
      final response = await _dio.get(
          "${EdusApi.studentPaymentSuccessCallback}/Fees/$transactionId",
          options: dio.Options(
            headers: Utils.setHeader(userController.token.value.toString()),
          ));

      // log("Callback response -> $data");

      if (response.statusCode == 200) {
        data = Map<String, dynamic>.from(response.data);

        isPaymentProcessing(false);
        await fetchFeesRecord(userController.studentId.value,
            userController.studentRecord.value.records?.first.id);
        Get.back();
        CustomSnackBar().snackBarSuccess(data['message']);
      } else {
        data = Map<String, dynamic>.from(response.data);
        isPaymentProcessing(false);
        CustomSnackBar().snackBarSuccess(data.toString());
      }
    } catch (e) {
      isPaymentProcessing(false);
    }
  }

  Future callRazorPayService(String amount, trxId) async {
    await RazorpayServices().openRazorpay(
      razorpayKey: razorPayApiKey,
      contactNumber:
          addPaymentModel.value.invoiceInfo?.studentInfo?.user?.phoneNumber ??
              "",
      emailId:
          addPaymentModel.value.invoiceInfo?.studentInfo?.user?.email ?? "",
      amount: double.parse(amount.toString()),
      userName: "",
      successListener: (PaymentResponse paymentResponse) async {
        if (paymentResponse.paymentStatus) {
          await confirmPaymentCallBack(trxId.toString());
        }
      },
      failureListener: (PaymentResponse paymentResponse) {
        if (!paymentResponse.paymentStatus) {
          isPaymentProcessing.value = false;
          CustomSnackBar().snackBarError(paymentResponse.message);
        }
      },
    );
  }

  Future<StudentAddPaymentModel> getFeesInvoice(invoiceId) async {
    try {
      isLoading(true);
      final response = await http.get(
          Uri.parse(EdusApi.studentFeesAddPayment(invoiceId)),
          headers: Utils.setHeader(userController.token.toString()));
//print(InfixApi.studentFeesAddPayment(invoiceId));
//print(Utils.setHeader(userController.token.toString()));
//print(response.body);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print(response.statusCode);
        print(
            'addPaymentModel.value.paymentMethods${addPaymentModel.value.paymentMethods}');
        addPaymentModel.value = StudentAddPaymentModel.fromJson(jsonData);

        if (addPaymentModel.value.bankAccounts!.isNotEmpty) {
          selectedBank.value =
              addPaymentModel.value.bankAccounts?.first ?? BankAccount();
        }

        addPaymentModel.value.paymentMethods?.insert(
            0, FeesPaymentMethod(paymentMethod: "Select Payment Method".tr));

        addInWallet.value = 0.0;
        addWalletList.clear();
        amountList.clear();
        paidAmountList.clear();
        dueList.clear();
        noteList.clear();
        feeTypeList.clear();
        totalPaidAmount.value = 0.0;
        isPaymentProcessing.value = false;

        for (var element in addPaymentModel.value.invoiceDetails!) {
          addWalletList.add(0.0);

          feeTypeList.add(element.feesType);

          amountList.add(element.amount);

          dueList.add(element.dueAmount);

          paidAmountList.add(0.0);

          noteList.add(" ");
        }

        isLoading(false);
      } else {
        throw Exception('Failed to load');
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
    return addPaymentModel.value;
  }

  Future<void> fetchFeesRecord(studentId, recordId) async {
    try {
      isFeesLoading(true);
      final response = await http.get(
        Uri.parse(EdusApi.getFeeApi(studentId)),
        headers: Utils.setHeader(userController.token.toString()),
      );
      print(recordId);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        Iterable list = jsonData;
        feesRecordList.value =
            list.map((model) => ClassRecord.fromJson(model)).toList();
        for (var record in feesRecordList.value) {
          if (record.recordId == recordId) {
            feesRecord.value = record;
            print(feesRecord.value.className);
            print(feesRecord.value.feesInvoice?.length);
          }
        }
        //  feesRecord.value = feesRecordList.value.firstWhereOrNull((record) => record.recordId == recordId)??ClassRecord();
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error, t) {
      log("Error: $error");
      debugPrint(t.toString());
    } finally {
      if (feesRecordList.value.isNotEmpty) {}

      isFeesLoading(false);
    }
  }

  @override
  void onInit() {
    fetchFeesRecord(userController.studentId.value,
        userController.studentRecord.value.records?.first.id);
    // plugin.initialize(publicKey: payStackPublicKey);
    super.onInit();
  }
}
