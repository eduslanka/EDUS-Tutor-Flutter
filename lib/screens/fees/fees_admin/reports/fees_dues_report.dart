import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeDueReportModel.dart';
import 'package:http/http.dart' as http;

import 'fees_report_search_widget.dart';

class AdminFeesDueReport extends StatefulWidget {
  const AdminFeesDueReport({Key? key}) : super(key: key);

  @override
  _AdminFeesDueReportState createState() => _AdminFeesDueReportState();
}

class _AdminFeesDueReportState extends State<AdminFeesDueReport> {
  String? _token;

  Future<FeesDueReportModel>? searchData;

  Future<FeesDueReportModel> getSearchData(Map data) async {
    final response = await http.post(Uri.parse(InfixApi.adminFeesDueSearch),
        body: jsonEncode(data), headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {

      try {
        var jsonData = jsonDecode(response.body);

        return FeesDueReportModel.fromJson(jsonData);
      }catch(e,tr){
        print("$e");
        tr.printInfo();
        return FeesDueReportModel.fromJson({});
      }

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
        title: "Due Report",
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          FeesReportSearchWidget(
            onTap: (dateTime, classId, sectionId) {
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
          FutureBuilder<FeesDueReportModel>(
            future: searchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.feesDues!.isEmpty) {
                    return Utils.noDataWidget();
                  } else {
                    return ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        if (snapshot.data!.feesDues?[index] != null) {
                          return const Divider();
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      itemCount: snapshot.data?.feesDues?.length ?? 0,
                      itemBuilder: (context, index) {
                        FeesDue? feesDue = snapshot.data?.feesDues?[index];

                        if (feesDue != null) {
                          return PaymentReportWidget(feesDue);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
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
  final FeesDue feesDue;

  const PaymentReportWidget(this.feesDue, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        feesDue.name ?? 'NA',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Due Date'.tr,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      feesDue.dueDate.toString(),
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
                      'Admission No.'.tr,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      feesDue.admissionNo.toString(),
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      feesDue.rollNo.toString(),
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Amount'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(feesDue.amount.toString())
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
                        'Paid'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(feesDue.paid.toString())
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
                        'Waiver'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(feesDue.waiver.toString())
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
                        'Fine'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(feesDue.fine.toString())
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
                        'Balance'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(feesDue.balance.toString())
                            .toStringAsFixed(2),
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
