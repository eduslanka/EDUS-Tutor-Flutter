// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/screens/fees/model/Fee.dart';
import '../../../utils/Utils.dart';

// import 'dart:developer';

class FeeService {
  final int _id;
  final String _token;

  FeeService(this._id, this._token);

  List<FeeElement> feeMap = [];
  List<double> totalMap = [];

  bool isNullOrEmpty(Object o) => "" == o;

  Future<List<FeeElement>> fetchFee() async {
    try {
      feeMap.clear();

      //Utils.showToast(InfixApi.getFeesUrl(_id));

      final response = await http.get(Uri.parse(EdusApi.getFeesUrl(_id)),
          headers: Utils.setHeader(_token.toString()));

      var jsonData = json.decode(response.body);

      bool isSuccess = jsonData['success'];
      var data = feeFromJson(response.body);

      if (isSuccess) {
        for (var f in data.data?.fees ?? []) {
          feeMap.add(FeeElement(
              feesName: f.feesName,
              dueDate: f.dueDate,
              amount: f.amount,
              paid: f.paid,
              balance: f.balance,
              discountAmount:
                  isNullOrEmpty(f.discountAmount) ? 0 : f.discountAmount,
              fine: f.fine,
              feesTypeId: f.feesTypeId,
              currencySymbol: data.data?.currencySymbol?.currencySymbol));
        }
      } else {
        Utils.showToast('try again later');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return feeMap;
  }

  Future<List<double>> fetchTotalFee() async {
    try {
      double amount = 0;
      double discount = 0;
      double fine = 0;
      double paid = 0;
      double balance = 0;

      final response = await http.get(Uri.parse(EdusApi.getFeesUrl(_id)),
          headers: Utils.setHeader(_token.toString()));

      var jsonData = json.decode(response.body);

      bool isSuccess = jsonData['success'];
      final data = feeFromJson(response.body);

      if (isSuccess) {
        for (var element in data.data?.fees ?? []) {
          amount = amount + double.parse(element.amount.toString());

          element.paid == 0
              ? paid = paid + 0.0
              : paid = paid + double.parse(element.paid.toString());

          element.fine == 0
              ? fine = fine + 0.0
              : fine = fine + double.parse(element.fine.toString());

          element.discountAmount == null || element.discountAmount == ""
              ? discount = discount + 0.0
              : discount =
                  discount + double.parse(element.discountAmount.toString());

          balance = balance + double.parse(element.balance.toString());
        }
        totalMap.add(amount);
        totalMap.add(discount);
        totalMap.add(fine);
        totalMap.add(paid);
        totalMap.add(balance);
      } else {
        Utils.showToast('try again later');
      }
    } catch (e) {
      print(e);
    }
    return totalMap;
  }
}
