// 🐦 Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/exception/DioException.dart';
import 'package:edus_tutor/utils/model/AdminDormitory.dart';
import 'package:edus_tutor/utils/model/RoomType.dart';

class AddDormitory extends StatefulWidget {
  const AddDormitory({super.key});

  @override
  _AddDormitoryState createState() => _AddDormitoryState();
}

class _AddDormitoryState extends State<AddDormitory> {
  TextEditingController nameController = TextEditingController();
  TextEditingController intakeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<AdminDormitoryList>? dormitories;
  Future<AdminRoomTypeList>? rooms;
  Response? response;
  Dio dio = Dio();
  String? _token;
  String? _schoolId;

  String? selectedType;

  var types = ['Boys', 'Girls'];

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });

    selectedType = 'Boys';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Dormitory',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: nameController,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: InputDecoration(hintText: 'Dormitory name'.tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: intakeController,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: InputDecoration(hintText: 'Intake'.tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: addressController,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: InputDecoration(hintText: 'Address'.tr),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: getRoomTypeDropdown(context, types),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextField(
                controller: noteController,
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: InputDecoration(hintText: 'Note'.tr),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 16.0, top: 50.0),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  addDormitoryData(
                          nameController.text,
                          intakeController.text,
                          addressController.text,
                          noteController.text,
                          selectedType?.substring(0, 1) ?? '')
                      .then((value) {
                    if (value) {
                      nameController.text = '';
                      intakeController.text = '';
                      noteController.text = '';
                      addressController.text = '';
                    }
                  });
                },
                child: Text("Save".tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRoomTypeDropdown(BuildContext context, List<String> typeList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: typeList.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                item,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedType = value as String;
          });
        },
        value: selectedType,
      ),
    );
  }

  Future<bool> addDormitoryData(String name, String intake, String address,
      String note, String type) async {
    await Utils.getStringValue('schoolId').then((value) {
      _schoolId = value;
    });

    FormData formData = FormData.fromMap({
      "dormitory_name": name,
      "type": type,
      "intake": intake,
      "address": address,
      "description": note,
      "school_id": _schoolId,
    });

    response = await dio
        .post(
      EdusApi.adminAddDormitory,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": _token.toString(),
        },
      ),
    )
        .catchError((e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Utils.showToast(errorMessage);
    });
    if (response?.statusCode == 200) {
      Utils.showToast('Dormitory Added'.tr);
      return true;
    } else {
      return false;
    }
  }
}
