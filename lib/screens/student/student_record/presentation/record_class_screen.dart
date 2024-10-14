import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../data/data_source/student_record_controller.dart';
import 'recorded_class_vedio.dart';

class RecordedClassesScreen extends StatelessWidget {
  final RecordedClassController _controller =
      Get.put(RecordedClassController(baseUrl: 'https://app.edustutor.com'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Recorded Classes',
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.isNotEmpty) {
          return Center(child: Text(_controller.errorMessage.value));
        }

        // Group by class names
        final classes = _controller.recordedClasses
            .map((rc) => rc.className)
            .toSet()
            .toList();

        if (classes.isEmpty) {
          return Center(child: Text('No recorded classes available.'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final className = classes[index];

            return ListTile(
              title: Text(
                className,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the screen showing the list of recorded videos for that class
                Get.to(() => RecordedClassVideosScreen(className: className));
              },
            );
          },
        );
      }),
    );
  }
}
