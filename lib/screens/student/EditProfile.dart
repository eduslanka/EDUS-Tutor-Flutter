// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/model/StudentDetailsModel.dart';

class EditProfile extends StatefulWidget {
  final String? id;
  final Function? updateData;

  const EditProfile({Key? key, this.id, this.updateData}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String _token = '';
  String _id = '';
  StudentDetailsModel _userDetails = StudentDetailsModel();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();

  String? maxDateTime;
  String minDateTime = '2019-01-01';
  DateTime? date;
  String? day, year, month;
  String? _selectedDate;
  String? _format;
  final DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  final DIO.Dio _dio = DIO.Dio();

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future<StudentDetailsModel>? profile;

  Future<StudentDetailsModel> getProfile() async {
    await Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    await Utils.getStringValue('id').then((value) {
      _id = value ?? '';
    });
    final response = await http.get(
        Uri.parse(InfixApi.getChildren(widget.id ?? _id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      _userDetails = StudentDetailsModel.fromJson(jsonData);
      return _userDetails;
    } else {
      throw Exception('Failed to load from api');
    }
  }

  Future updateData(
      {String? fieldName, String? value, DIO.MultipartFile? file}) async {
    await Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    await Utils.getStringValue('id').then((value) {
      _id = value ?? '';
    });
    DIO.FormData _formData;
    if (_file == null) {
      _formData = DIO.FormData.fromMap({
        "field_name": fieldName,
        fieldName ?? '': value,
        "id": _userDetails.studentData?.user?.id
      });
    } else {
      _formData = DIO.FormData.fromMap({
        "field_name": fieldName,
        fieldName ?? '': file,
        "id": _userDetails.studentData?.user?.id,
        "student_photo": await DIO.MultipartFile.fromFile(_file?.path ?? ''),
      });
    }

    var response = await _dio.post(
      InfixApi.updateStudent,
      options: DIO.Options(
        headers: Utils.setHeader(_token.toString()),
      ),
      data: _formData,
    );
    final data = Map<String, dynamic>.from(response.data);

    if (data['data']['flag'] == true) {
      if (_file != null) {
        await getProfile().then((value) {
          Utils.saveStringValue("image", value.studentData?.user?.studentPhoto ?? '');
        });
      }
      setState(() {});
      Navigator.of(context).pop(widget.updateData!(1));
    } else {}
  }

  @override
  void initState() {
    profile = getProfile();
    super.initState();
  }

  File? _file;
  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path ?? '');
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Edit Profile'),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(

        child: Column(

         // mainAxisSize: MainAxisSize.max,
          children: [


            FutureBuilder<StudentDetailsModel>(
                future: profile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                      // if we got our data
                    } else if (snapshot.hasData) {
                      _firstNameCtrl.text = snapshot.data?.studentData?.user?.firstName ?? '';
                      _lastNameCtrl.text = snapshot.data?.studentData?.user?.lastName ?? '';
                      _addressCtrl.text =
                          snapshot.data?.studentData?.user?.currentAddress ?? '';
                      maxDateTime = "2100-01-01";
                      minDateTime = "1900-01-01";
                      date =
                          DateTime.parse(snapshot.data?.studentData?.user?.dateOfBirth ?? '');
                      return Form(
                        key: _formKey,
                        child: Column(
                          // physics: NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,

                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Text(
                                "Profile Photo".tr,
                                style: Get.textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: pickDocument,
                                      child: TextFormField(
                                        enabled: false,
                                        keyboardType: TextInputType.text,
                                        style: Theme.of(context).textTheme.titleLarge,
                                        autovalidateMode: AutovalidateMode.disabled,
                                        decoration: InputDecoration(
                                          labelText: _file == null
                                              ? 'Select image'.tr
                                              : _file?.path.split('/').last ?? '',
                                          errorStyle: const TextStyle(
                                              color: Colors.pinkAccent,
                                              fontSize: 15.0),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () async {
                                      await updateData(
                                          fieldName: "student_photo",
                                          file: await DIO.MultipartFile.fromFile(
                                              _file?.path ?? ''));
                                    },
                                    icon: const Icon(
                                      Icons.save_as,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _file == null
                                ? const SizedBox.shrink()
                                : Image.file(
                                    _file ?? File(''),
                                    width: Get.width * 0.1,
                                    height: Get.height * 0.1,
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      controller: _firstNameCtrl,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your first name'.tr;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "First Name".tr,
                                        labelText: "First Name".tr,
                                        labelStyle:
                                            Theme.of(context).textTheme.headlineMedium,
                                        errorStyle: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 15.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () async {
                                      await updateData(
                                          fieldName: "first_name",
                                          value: _firstNameCtrl.text);
                                    },
                                    icon: const Icon(
                                      Icons.save_as,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      controller: _lastNameCtrl,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your last name'.tr;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Last Name".tr,
                                        labelText: "Last Name".tr,
                                        labelStyle:
                                            Theme.of(context).textTheme.headlineMedium,
                                        errorStyle: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 15.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () async {
                                      await updateData(
                                          fieldName: "last_name",
                                          value: _lastNameCtrl.text);
                                    },
                                    icon: const Icon(
                                      Icons.save_as,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      enabled: false,
                                      initialValue:
                                          "${date?.day}/${date?.month}/${date?.year}",
                                      decoration: InputDecoration(
                                        hintText: "Date of birth".tr,
                                        labelText: "Date of birth".tr,
                                        labelStyle:
                                            Theme.of(context).textTheme.headlineMedium,
                                        errorStyle: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 15.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(
                                        context,
                                        pickerTheme: const DateTimePickerTheme(
                                          confirm: Text('Done',
                                              style: TextStyle(color: Colors.red)),
                                          cancel: Text('Cancel',
                                              style: TextStyle(color: Colors.cyan)),
                                        ),
                                        minDateTime: DateTime.parse(minDateTime),
                                        maxDateTime: DateTime.parse(maxDateTime ?? ''),
                                        initialDateTime: date,
                                        dateFormat: _format,
                                        locale: _locale,
                                        onClose: () => print("----- onClose -----"),
                                        onCancel: () => print('onCancel'),
                                        onConfirm: (dateTime, List<int> index) async {
                                          date = dateTime;
                                          _selectedDate =
                                              '${date?.year}-${getAbsoluteDate(date?.month ?? 0)}-${getAbsoluteDate(date?.day ?? 0)}';

                                          print(_selectedDate);
                                          await updateData(
                                              fieldName: "date_of_birth",
                                              value: _selectedDate);
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.save_as,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 15.0.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      maxLines: 3,
                                      keyboardType: TextInputType.text,
                                      style: Theme.of(context).textTheme.titleLarge,
                                      controller: _addressCtrl,
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your address'.tr;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Current Address".tr,
                                        labelText: "Current Address".tr,
                                        labelStyle:
                                            Theme.of(context).textTheme.headlineMedium,
                                        errorStyle: const TextStyle(
                                          color: Colors.pinkAccent,
                                          fontSize: 15.0,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  IconButton(
                                    onPressed: () async {
                                      await updateData(
                                          fieldName: "current_address",
                                          value: _addressCtrl.text);
                                    },
                                    icon: const Icon(
                                      Icons.save_as,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
