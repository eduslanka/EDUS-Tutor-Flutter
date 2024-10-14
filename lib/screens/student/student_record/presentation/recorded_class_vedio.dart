import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/CustomAppBarWidget.dart';
import '../data/data_source/student_record_controller.dart';
import 'recoded_classe_card.dart';

class RecordedClassVideosScreen extends StatelessWidget {
  final String className;

  RecordedClassVideosScreen({required this.className});

  final RecordedClassController _controller =
      Get.find<RecordedClassController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: '$className - Recorded Classes',
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final filteredClasses = _controller.recordedClasses
            .where((rc) => rc.className == className)
            .toList();

        if (filteredClasses.isEmpty) {
          return Center(
            child: Text('No recorded videos for $className.'),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: filteredClasses.length,
          itemBuilder: (context, index) {
            final recordedClass = filteredClasses[index];

            return RecordedClassCard(recordedClass: recordedClass);
          },
        );
      }),
    );
  }
}
