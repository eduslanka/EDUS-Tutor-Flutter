import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../model/student_record_model.dart';

class RecordedClassController extends GetxController {
  final String baseUrl;
  RecordedClassController({required this.baseUrl});

  var isLoading = false.obs;
  var recordedClasses = <RecordedClass>[].obs;
  var errorMessage = ''.obs;

  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchRecordedClasses();
  }

  Future<void> fetchRecordedClasses() async {
    try {
      isLoading(true);
      final response = await _dio.get('$baseUrl/student-recorded-class');

      if (response.statusCode == 200) {
        // Parse the response and update the list of recorded classes
        var data = RecordedClassListResponse.fromJson(response.data);
        recordedClasses.value = data.recordedClasses;
      } else {
        errorMessage.value = 'Failed to load data: ${response.statusMessage}';
      }
    } catch (e) {
      // Handle exceptions
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }
}
