import 'package:flutter/material.dart';
import 'package:edus_tutor/config/app_size.dart';

import '../../../../utils/Utils.dart';
import '../../../../webview/launch_webview.dart';
import '../data/model/student_record_model.dart';
import 'video_player_page.dart';

class RecordedClassCard extends StatelessWidget {
  final RecordedClass recordedClass;
  final bool isAllow;
  const RecordedClassCard({
    Key? key,
    required this.recordedClass,
    required this.isAllow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isAllow) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchWebView(
                launchUrl: recordedClass.downloadPath ?? '',
                title: recordedClass.className,
              ),
            ),
          );
        } else {
          Utils.showToast('Action denied. Contact Admin...!.');
        }
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 3,
        child: Container(
          width: screenWidth(390, context),
          // height: 140,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Text('Teacher: ${recordedClass.teacher}'),
                    Text('Date: ${recordedClass.dateOfClass}'),
                    Text('Time: ${recordedClass.classTime ?? 'N/A'}'),
                    Text('Day: ${recordedClass.dayOfWeek?.trim() ?? 'N/A'}'),
                    const SizedBox(height: 5.0),
                    if (recordedClass.onlineClassTopic != null)
                      Text(
                        'Topic: ${recordedClass.onlineClassTopic!}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
                Icon(
                  Icons.play_circle_fill_outlined,
                  color: Colors.black,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
