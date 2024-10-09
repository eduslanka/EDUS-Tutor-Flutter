import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/data_source/student_record_controller.dart';


class RecordedClassesScreen extends StatelessWidget {
  final RecordedClassController _controller = Get.put(RecordedClassController(baseUrl: 'https://app.edustutor.com'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recorded Classes'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_controller.errorMessage.isNotEmpty) {
          return Center(child: Text(_controller.errorMessage.value));
        }

        if (_controller.recordedClasses.isEmpty) {
          return Center(child: Text('No recorded classes found.'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: _controller.recordedClasses.length,
          itemBuilder: (context, index) {
            final recordedClass = _controller.recordedClasses[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail of the class
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        recordedClass.downloadPath,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 80.0);
                        },
                      ),
                    ),
                    SizedBox(width: 12.0),
                    
                    // Class details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recordedClass.className,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text('Teacher: ${recordedClass.teacher}'),
                          Text('Date: ${recordedClass.dateOfClass}'),
                          Text('Time: ${recordedClass.classTime ?? 'N/A'}'),
                          Text('Day: ${recordedClass.dayOfWeek?.trim() ?? 'N/A'}'),
                          SizedBox(height: 5.0),
                          if (recordedClass.onlineClassTopic != null)
                            Text('Topic: ${recordedClass.onlineClassTopic!}', style: TextStyle(color: Colors.grey)),
                          
                          // Download button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {
                                // Handle the download logic here
                                print('Download link: ${recordedClass.downloadPath}');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
