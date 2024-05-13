import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeTransactions.dart';

class FeeTransactionView extends StatefulWidget {
  final int? invoiceId;
  const FeeTransactionView({Key? key, this.invoiceId}) : super(key: key);
  @override
  _FeeTransactionViewState createState() => _FeeTransactionViewState();
}

class _FeeTransactionViewState extends State<FeeTransactionView> {
  Future<FeeTransactionsList>? fees;
  String? _token = '';

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        fees = getFeesInvoice();
      });
    });
    super.initState();
  }

  Future<FeeTransactionsList> getFeesInvoice() async {
    final response = await http.post(Uri.parse(InfixApi.adminFeesViewPayment),
        body: jsonEncode({'invoiceId': widget.invoiceId}),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      return FeeTransactionsList.fromJson(jsonData['feesTranscations']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Transactions',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<FeeTransactionsList>(
        future: fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: snapshot.data?.feeTransactions.length ?? 0,
                itemBuilder: (context, index) {
                  FeesTranscation transactions =
                      snapshot.data?.feeTransactions[index] ?? FeesTranscation();

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      transactions.date ?? 'NA',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 14),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Payment Method'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      transactions.paymentMethod.toString(),
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Change Method'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      transactions.changeMethod.toString(),
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Paid'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      transactions.paidAmount.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Waiver'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      transactions.waiver.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Fine'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      transactions.fine.toString(),
                                      maxLines: 1,
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}
