// import 'dart:io';

// import 'package:eko_jitsi/eko_jitsi.dart';
// import 'package:eko_jitsi/eko_jitsi_listener.dart';
// import 'package:eko_jitsi/feature_flag/feature_flag_enum.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:edus_tutor/utils/CustomAppBarWidget.dart';

// class JitsiMeetClass extends StatefulWidget {
//   final String? meetingId;
//   final String? meetingSubject;
//   final String? userName;
//   final String? userEmail;

//   const JitsiMeetClass({Key? key, 
//     this.meetingId,
//     this.meetingSubject,
//     this.userEmail,
//     this.userName,
//   }) : super(key: key);

//   @override
//   _JitsiMeetClassState createState() => _JitsiMeetClassState();
// }

// class _JitsiMeetClassState extends State<JitsiMeetClass> {
//   final serverText = TextEditingController();
//   final roomText = TextEditingController();
//   final subjectText = TextEditingController();
//   final nameText = TextEditingController();
//   final emailText = TextEditingController();
//   final iosAppBarRGBAColor = TextEditingController(text: "#0080FF80");
//   bool isAudioOnly = true;
//   bool isAudioMuted = true;
//   bool isVideoMuted = true;

//   @override
//   void initState() {
//     super.initState();

//     roomText.text = widget.meetingId ?? '';
//     subjectText.text = widget.meetingSubject ?? '';
//     nameText.text = widget.userName ?? '';
//     emailText.text = widget.userEmail ?? '';

//     EkoJitsi.addListener(
//       EkoJitsiListener(onConferenceWillJoin: ({message}) {
//         debugPrint("will join with message: $message");
//       }, onConferenceJoined: ({message}) {
//         debugPrint("joined with message: $message");
//       }, onConferenceTerminated: ({message}) {
//         debugPrint("terminated with message: $message");
//       }),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     EkoJitsi.removeAllListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         title: "Join",
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16.0,
//         ),
//         child: meetConfig(context),
//       ),
//     );
//   }

//   Widget meetConfig(context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           const SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Theme.of(context).primaryColor,
//             title: const Text(
//               "Audio Only",
//             ),
//             value: isAudioOnly,
//             onChanged: _onAudioOnlyChanged,
//           ),
//           const SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Theme.of(context).primaryColor,
//             title: const Text(
//               "Audio Muted",
//             ),
//             value: isAudioMuted,
//             onChanged: _onAudioMutedChanged,
//           ),
//           const SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Theme.of(context).primaryColor,
//             title: const Text(
//               "Video Muted",
//             ),
//             value: isVideoMuted,
//             onChanged: _onVideoMutedChanged,
//           ),
//           const Divider(
//             height: 48.0,
//             thickness: 2.0,
//           ),
//           SizedBox(
//             height: 45.0,
//             width: double.maxFinite,
//             child: ElevatedButton(
//               onPressed: () {
//                 _joinMeeting();
//               },
//               child: const Text(
//                 "Watch now",
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateColor.resolveWith(
//                       (states) => Theme.of(context).primaryColor)),
//             ),
//           ),
//           const SizedBox(
//             height: 48.0,
//           ),
//         ],
//       ),
//     );
//   }

//   _onAudioOnlyChanged(bool? value) {
//     setState(() {
//       isAudioOnly = value ?? false;
//     });
//   }

//   _onAudioMutedChanged(bool? value) {
//     setState(() {
//       isAudioMuted = value ?? false;
//     });
//   }

//   _onVideoMutedChanged(bool? value) {
//     setState(() {
//       isVideoMuted = value ?? false;
//     });
//   }

//   _joinMeeting() async {
//     String serverUrl = (serverText.text.trim().isEmpty ? null : serverText.text) ?? '';

//     // Enable or disable any feature flag here
//     // If feature flag are not provided, default values will be used
//     // Full list of feature flags (and defaults) available in the README
//     Map<FeatureFlagEnum, bool> featureFlags = {
//       FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//     };
//     if (!kIsWeb) {
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       } else if (Platform.isIOS) {
//         // Disable PIP on iOS as it looks weird
//         featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
//       }
//     }
//     // Define meetings options here
//     var options = JitsiMeetingOptions()
//       ..room = roomText.text
//       ..serverURL = serverUrl
//       ..subject = subjectText.text
//       ..userDisplayName = nameText.text
//       ..userEmail = emailText.text
//       ..audioOnly = isAudioOnly
//       ..audioMuted = isAudioMuted
//       ..videoMuted = isVideoMuted
//       ..featureFlags.addAll(featureFlags);
//     // ..webOptions = {
//     //   "roomName": roomText.text,
//     //   "width": "100%",
//     //   "height": "100%",
//     //   "enableWelcomePage": false,
//     //   "chromeExtensionBanner": null,
//     //   "userInfo": {"displayName": nameText.text}
//     // };

//     debugPrint("EkoJitsiingOptions: $options");
//     await EkoJitsi.joinMeeting(
//       options,
//       listener: EkoJitsiListener(onConferenceWillJoin: ({message}) {
//         debugPrint("${options.room} will join with message: $message");
//       }, onConferenceJoined: ({message}) {
//         debugPrint("${options.room} joined with message: $message");
//       }, onConferenceTerminated: ({message}) {
//         debugPrint("${options.room} terminated with message: $message");
//       }),
//     );
//   }
// }
