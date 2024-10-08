// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/zoom_meeting.dart';
import 'package:edus_tutor/utils/permission_check.dart';
import 'package:edus_tutor/webview/launch_webview.dart';
import 'ScaleRoute.dart';

// ignore: must_be_immutable
class ZoomMeetingRow extends StatefulWidget {
  ZoomMeeting zoomMeeting;

  ZoomMeetingRow(this.zoomMeeting, {super.key});

  @override
  // ignore: no_logic_in_create_state
  _DormitoryScreenState createState() => _DormitoryScreenState(zoomMeeting);
}

class _DormitoryScreenState extends State<ZoomMeetingRow> {
  ZoomMeeting zoomMeeting;

  _DormitoryScreenState(this.zoomMeeting);

  @override
  void initState() {
    PermissionCheck().checkPermissions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            zoomMeeting.topic,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: ScreenUtil().setSp(15)),
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
                        'Start Date',
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
                        '${zoomMeeting.startDate}',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        'Time',
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
                        '${zoomMeeting.startTime} - ${DateFormat('hh:mm a').format(zoomMeeting.endTime ?? DateTime.now())}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
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
                        '${zoomMeeting.password}',
                        maxLines: 1,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                      child: Text(
                        'Join',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      // borderSide:
                      //     BorderSide(width: 1, color: Color(0xff053EFF)),
                      onPressed: () async {
                        final url = EdusApi.getJoinMeetingUrlApp(
                            mid: zoomMeeting.meetingId);

                        debugPrint(
                            'App URL: ${EdusApi.getJoinMeetingUrlApp(mid: zoomMeeting.meetingId)}');
                        debugPrint(
                            'Web URL: ${EdusApi.getJoinMeetingUrlWeb(mid: zoomMeeting.meetingId)}');
                        // ignore: deprecated_member_use
                        if (await canLaunch(url)) {
                          // ignore: deprecated_member_use
                          await launch(url);
                        } else {
                          Navigator.push(
                              context,
                              ScaleRoute(
                                  page: LaunchWebView(
                                launchUrl: EdusApi.getJoinMeetingUrlWeb(
                                    mid: zoomMeeting.meetingId),
                                title: zoomMeeting.topic,
                              )));
                        }
                      }),
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
                  colors: [Color(0xff053EFF), Color(0xff053EFF)]),
            ),
          ),
        ],
      ),
    );
  }
}
