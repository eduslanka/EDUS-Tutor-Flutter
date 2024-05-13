import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeeFineReportModel.dart';
import 'package:http/http.dart' as http;

import 'fees_report_search_widget.dart';

class AdminFeesFineReport extends StatefulWidget {
  const AdminFeesFineReport({Key? key}) : super(key: key);

  @override
  _AdminFeesFineReportState createState() => _AdminFeesFineReportState();
}

class _AdminFeesFineReportState extends State<AdminFeesFineReport> {
  String? _token;

  Future<FeeFineReportModel>? searchData;

  Future<FeeFineReportModel> getSearchData(Map data) async {
    final response = await http.post(Uri.parse(InfixApi.adminFeesFineSearch),

        body: jsonEncode(data), headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeFineReportModel.fromJson(jsonData);
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
        title: "Fine Report",
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
          FutureBuilder<FeeFineReportModel>(
            future: searchData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.fineReport!.isEmpty) {
                    return Utils.noDataWidget();
                  } else {
                    var total = 0.0;
                    for (var element in snapshot.data!.fineReport!.values) {
                      total += element.fine ?? 0;
                    }
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Total".tr +
                                ": " +
                                double.parse(total.toString()).toStringAsFixed(2),
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
                            return const Divider();
                          },
                          itemCount: snapshot.data?.fineReport?.length ?? 0,
                          itemBuilder: (context, index) {
                            FineReport? report = snapshot.data?.fineReport?.values
                                .elementAt(index);

                            if (report != null) {
                              return FineReportWidget(report);
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

class FineReportWidget extends StatelessWidget {
  final FineReport fineReport;

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
                        'Fine'.tr,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        double.parse(fineReport.fine.toString())
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
                        fineReport.dueDate.toString(),
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
