// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/download_dialog.dart';
import 'package:infixedu/utils/model/LeaveAdmin.dart';
import 'package:infixedu/utils/model/StudentLeave.dart';
import 'package:infixedu/utils/permission_check.dart';
import 'package:infixedu/utils/widget/Line.dart';

// ignore: must_be_immutable
class LeaveListStudent extends StatefulWidget {
  String? id;

  LeaveListStudent({Key? key, this.id}) : super(key: key);

  @override
  _LeaveListStudentState createState() => _LeaveListStudentState();
}

class _LeaveListStudentState extends State<LeaveListStudent> {
  var id;

  String? _token;
  Future<StudentMyLeavesList>? myLeaves;
  Future? pendingLeaves;
  Future? approvedLeaves;
  Future? rejectedLeaves;

  var progress = "Download".tr;

  var received;

  // final _globalKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
      Utils.getStringValue('id').then((value) {
        setState(() {
          myLeaves = getMyLeaves(
              widget.id != null ? int.parse(widget.id ?? '') : int.parse(value ?? ''));
          pendingLeaves = getPendingLeaves(
              widget.id != null ? int.parse(widget.id ?? '') : int.parse(value ?? ''), "P");
          approvedLeaves = getPendingLeaves(
              widget.id != null ? int.parse(widget.id ?? '') : int.parse(value ?? ''), "A");
          rejectedLeaves = getPendingLeaves(
              widget.id != null ? int.parse(widget.id ?? '') : int.parse(value ?? ''), "C");
        });
      });
    });
  }

  static List<Tab> tabs = <Tab>[
    Tab(
      text: 'Pending'.tr,
    ),
    Tab(
      text: 'Approved'.tr,
    ),
    Tab(
      text: 'Rejected'.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWidget(title: 'Leave List'),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  'My Leaves'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                child: FutureBuilder<StudentMyLeavesList>(
                  future: myLeaves,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.studentMyLeave.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data?.studentMyLeave[index].type ?? '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${snapshot.data?.studentMyLeave[index].days.toString()}' + ' ' + "days".tr,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    } else {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 15.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xfff3e5f5).withOpacity(0.5),
                        Colors.white
                      ]),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: DefaultTabController(
                    length: tabs.length,
                    initialIndex: 0,
                    child: Builder(
                      builder: (context) {
                        final TabController tabController =
                            DefaultTabController.of(context);
                        tabController.addListener(() {
                          if (tabController.indexIsChanging) {
                            print(tabController.index);
                          }
                        });
                        return Scaffold(
                          backgroundColor: Colors.white,
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            centerTitle: false,
                            titleSpacing: 0,
                            title: Container(
                              child: Text(
                                'Leave List'.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            bottom: TabBar(
                              labelColor: Colors.black,
                              labelPadding: EdgeInsets.zero,
                              indicatorColor: Colors.purple,
                              tabs: tabs,
                              indicatorPadding: EdgeInsets.zero,
                              labelStyle: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: TabBarView(
                              children: [
                                pendingLeaves == null ? SizedBox() : getLeaves(pendingLeaves!),
                                approvedLeaves == null ? SizedBox() : getLeaves(approvedLeaves!),
                                rejectedLeaves == null ? SizedBox() : getLeaves(rejectedLeaves!),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget getLeaves(Future future) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<dynamic>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.leaves.isNotEmpty) {
              var data = snapshot.data?.leaves;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showAlertDialog(context, data?[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data[index].type == null ||
                                          data[index].type == ''
                                      ? 'N/A'
                                      : data[index].type,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              SizedBox(
                                width: 80.0,
                                child: Text(
                                  'View'.tr,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          color: Colors.deepPurpleAccent,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Apply Date'.tr,
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
                                      data[index].applyDate ?? 'N/A',
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
                                      'From'.tr,
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
                                      data[index].leaveFrom ?? 'N/A',
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
                                      'To'.tr,
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
                                      data[index].leaveTo ?? 'N/A',
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
                                      'Status'.tr,
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
                                    getStatus(context, data[index].status),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 0.5,
                            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [Colors.purple, Colors.deepPurple]),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == 'P') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.yellow.shade600),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Pending'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (status == 'A') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.green.shade400),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Approved'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (status == 'R' || status == 'C') {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.red),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Rejected'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  showAlertDialog(BuildContext context, LeaveAdmin data) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Reason'.tr + ': ' + '${data.reason}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Leave To'.tr,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    data.leaveTo ?? '',
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
                                    'Apply Date'.tr,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    data.applyDate ?? '',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Leave Type'.tr,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    data.type ?? '',
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
                                    'Leave From'.tr,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    data.leaveFrom ?? '',
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
                      BottomLine(),
                      data.file == null || data.file == ''
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                PermissionCheck().checkPermissions(context);
                                showDialog<void>(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DownloadDialog(
                                      file: data.file,
                                      title: data.reason,
                                    );
                                  },
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Attached File'.tr + ': ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Download'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<StudentMyLeavesList> getMyLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.studentApplyLeave(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StudentMyLeavesList.fromJson(jsonData['data']['my_leaves']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList> getApprovedLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.approvedLeaves(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data']['aprrove_request']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList>? getPendingLeaves(var id, purpose) async {
    final response = await http.get(
        Uri.parse(InfixApi.pendingLeaves(id, purpose)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data']['pending_leaves']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LeaveAdminList> getRejectedLeaves(var id) async {
    final response = await http.get(Uri.parse(InfixApi.rejectedLeaves(id)),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return LeaveAdminList.fromJson(jsonData['data']['rejected_request']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
