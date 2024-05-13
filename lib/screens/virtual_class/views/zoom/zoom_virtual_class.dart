import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/user_controller.dart';
import '../../../../utils/CustomAppBarWidget.dart';
import '../../../../utils/Utils.dart';
import '../../../../utils/apis/Apis.dart';
import '../../../../utils/widget/ScaleRoute.dart';
import '../../../../webview/launch_webview.dart';
import '../../models/virtual_class_model.dart';

class ZoomVirtualClass extends StatefulWidget {
  final String? type;
  const ZoomVirtualClass({Key? key, this.type}) : super(key: key);
  @override
  State<ZoomVirtualClass> createState() => _ZoomVirtualClassState();
}

class _ZoomVirtualClassState extends State<ZoomVirtualClass> {
  final UserController _userController = Get.put(UserController());
  String? _token;
  Future<VirtualClass>? virtualClass;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        _userController.getIdToken();
        if (_userController.role.value == "2" ||
            _userController.role.value == "3") {
          _userController.selectedRecord.value =
              _userController.studentRecord.value.records?.first ?? Record();
          virtualClass =
              getAllMeeting(recordId: _userController.selectedRecord.value.id);
        } else {
          virtualClass = getAllMeeting();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.type == "class" ? 'Virtual Class' : 'Virtual Meeting',
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _userController.role.value == "2" || _userController.role.value == "3"
              ? widget.type == "class"
                  ? StudentRecordWidget(
                      onTap: (Record record) {
                        setState(() {
                          _userController.selectedRecord.value = record;

                          virtualClass = getAllMeeting(
                              recordId:
                                  _userController.selectedRecord.value.id);
                        });
                      },
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
          Expanded(
            child: FutureBuilder<VirtualClass>(
              future: virtualClass,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.data!.meetings!.isEmpty) {
                    return Utils.noDataWidget();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: snapshot.data?.data?.meetings?.length ?? 0,
                    itemBuilder: (context, index) {
                      return JitsiMeetingRow(
                          snapshot.data?.data?.meetings?[index] ?? Meeting());
                    },
                  );
                } else {
                  return const Center(child: CupertinoActivityIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<VirtualClass> getAllMeeting({int? recordId}) async {
    final _url = widget.type == "class"
        ? Uri.parse(InfixApi.getVirtualClass(recordId ?? 0, 'zoom'))
        : Uri.parse(InfixApi.getVirtualMeeting('zoom'));

    final response =
        await http.get(_url, headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return VirtualClass.fromJson(jsonData);
    } else {
      throw Exception('Failed to load');
    }
  }
}

class JitsiMeetingRow extends StatelessWidget {
  final Meeting meeting;

  const JitsiMeetingRow(this.meeting, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            meeting.topic.toString(),
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Topic',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      meeting.topic.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Meeting ID',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      meeting.meetingId.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Duration',
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        meeting.meetingDuration.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Start Time',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(meeting.startTime ?? DateTime(2000)),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: meeting.status == "join" ||
                            meeting.status == "started"
                        ? Theme.of(context).primaryColor
                        : meeting.status == "waiting"
                            ? Colors.amberAccent
                            : Colors.red,
                  ),
                  child: Text(
                    meeting.status?.capitalizeFirst ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (meeting.status == "join" ||
                        meeting.status == 'started') {
                      final _url = InfixApi.getJoinMeetingUrlApp(
                          mid: meeting.meetingId);

                      // ignore: deprecated_member_use
                      if (await canLaunch(_url)) {
                        // ignore: deprecated_member_use
                        await launch(_url);
                      } else {
                        Navigator.push(
                            context,
                            ScaleRoute(
                                page: LaunchWebView(
                              launchUrl: InfixApi.getJoinMeetingUrlWeb(
                                  mid: meeting.meetingId),
                              title: meeting.topic.toString(),
                            )));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 0.5,
            margin: const EdgeInsets.only(top: 10.0),
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
  }
}
