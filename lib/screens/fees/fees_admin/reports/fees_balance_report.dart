import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/controller/system_controller.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeBalanceReportModel.dart';

import 'fees_report_search_widget.dart';
import 'package:http/http.dart' as http;

class AdminFeesBalanceReport extends StatefulWidget {
  const AdminFeesBalanceReport({Key? key}) : super(key: key);

  @override
  _AdminFeesBalanceReportState createState() => _AdminFeesBalanceReportState();
}

class _AdminFeesBalanceReportState extends State<AdminFeesBalanceReport> {
  final SystemController _systemController = Get.put(SystemController());
  String? _token;

  Future<FeesBalanceReportModel>? searchData;

  Future<FeesBalanceReportModel> getSearchData(Map data) async {
    final response = await http.post(Uri.parse(InfixApi.adminFeesBalanceSearch),
        body: jsonEncode(data), headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeesBalanceReportModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    Utils.getStringValue('token').then((value) async {
      setState(() {
        _token = value ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Balance Report",
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          FeesReportSearchWidget(
            onTap: (dateTime, classId, sectionId) async {
              if (dateTime == null || dateTime == "") {
                Utils.showToast("Select a date first");
              } else {
                Map data = {
                  'date_range': dateTime,
                  'class': classId,
                  'section': sectionId,
                };
                setState(() {
                  searchData = getSearchData(data);
                });
              }
            },
          ),
          FutureBuilder<FeesBalanceReportModel>(
            future: searchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.balanceReport!.isEmpty) {
                    return Utils.noDataWidget();
                  } else {
                    var total = 0.0;
                    for (var element in snapshot.data?.balanceReport ?? []) {
                      if (element != null) {
                        total += element.balance;
                      }
                    }
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Total".tr +
                                ": " +
                                "${double.parse(total.toString()).toStringAsFixed(2)}${_systemController.systemSettings.value.data?.currencySymbol}",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            if (snapshot.data!.balanceReport?[index] != null) {
                              return const Divider();
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                          itemCount: snapshot.data?.balanceReport?.length ?? 0,
                          itemBuilder: (context, index) {
                            BalanceReport balanceReport =
                                snapshot.data?.balanceReport?[index] ?? BalanceReport();

                            if (balanceReport != null) {
                              return PaymentReportWidget(balanceReport);
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    );
                  }
                } else {
                  return const Center(child: SizedBox.shrink());
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class PaymentReportWidget extends StatelessWidget {
  final BalanceReport paymentReport;

  const PaymentReportWidget(this.paymentReport, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        paymentReport.name ?? 'NA',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
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
                        'Admission No.'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        paymentReport.admissionNo.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Roll'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        paymentReport.rollNo ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Balance'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(paymentReport.balance.toString())
                            .toStringAsFixed(2),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Due Date'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        paymentReport.dueDate.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 12),
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
  }
}
