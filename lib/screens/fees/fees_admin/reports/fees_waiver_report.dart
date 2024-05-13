import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeWaiverReportModel.dart';
import 'package:http/http.dart' as http;

import 'fees_report_search_widget.dart';

class AdminFeesWaiverReport extends StatefulWidget {
  const AdminFeesWaiverReport({Key? key}) : super(key: key);

  @override
  _AdminFeesWaiverReportState createState() => _AdminFeesWaiverReportState();
}

class _AdminFeesWaiverReportState extends State<AdminFeesWaiverReport> {
  String? _token;

  Future<FeeWaiverReportModel>? searchData;

  Future<FeeWaiverReportModel> getSearchData(Map data) async {
    final response = await http.post(Uri.parse(InfixApi.adminFeesWaiverSearch),
        body: jsonEncode(data), headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeWaiverReportModel.fromJson(jsonData);
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
        title: "Waiver Report",
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
          FutureBuilder<FeeWaiverReportModel>(
            future: searchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.waiverReport!.isEmpty) {
                    return Utils.noDataWidget();
                  } else {
                    var total = 0.0;
                    for (var element in snapshot.data!.waiverReport!.values) {
                      total += (element.waiver ?? 0);
                    }

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Total" ": " +
                                double.parse(total.toString()).toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemCount: snapshot.data?.waiverReport?.length ?? 0,
                          itemBuilder: (context, index) {
                            WaiverReport? report = snapshot
                                .data?.waiverReport?.values
                                .elementAt(index);

                            return FineReportWidget(report ?? WaiverReport());
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

class FineReportWidget extends StatelessWidget {
  final WaiverReport fineReport;

  const FineReportWidget(this.fineReport, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        fineReport.name ?? 'NA',
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
                        fineReport.admissionNo.toString(),
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
                        fineReport.rollNo ?? "",
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
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(fineReport.waiver.toString())
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
                        fineReport.dueDate.toString() ?? '',
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
