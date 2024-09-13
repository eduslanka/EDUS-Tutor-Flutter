import 'dart:convert';
import 'dart:io';

import 'package:edus_tutor/config/app_size.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/StudentDetailsModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _dobController = TextEditingController();

  bool _isLoading = false;
  File? _file;
  DateTime? date;
  String? _selectedDate;

  final DIO.Dio _dio = DIO.Dio();

  Future<StudentDetailsModel> getProfile() async {
    _token = await Utils.getStringValue('token') ?? '';
    _id = await Utils.getStringValue('id') ?? '';

    final response = await http.get(
      Uri.parse(EdusApi.getChildren(widget.id ?? _id)),
      headers: Utils.setHeader(_token),
    );

    if (response.statusCode == 200) {
      _userDetails = StudentDetailsModel.fromJson(json.decode(response.body));
      return _userDetails;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future updateData({String? fieldName, String? value}) async {
    setState(() => _isLoading = true);
    _token = await Utils.getStringValue('token') ?? '';
    _id = await Utils.getStringValue('id') ?? '';

    DIO.FormData _formData = DIO.FormData.fromMap({
      "field_name": fieldName,
      fieldName ?? '': value,
      "id": _userDetails.studentData?.user?.id,
      if (_file != null)
        "student_photo": await DIO.MultipartFile.fromFile(_file!.path),
    });

    try {
      var response = await _dio.post(
        EdusApi.updateStudent,
        options: DIO.Options(headers: Utils.setHeader(_token)),
        data: _formData,
      );

      if (response.data['data']['flag'] == true && _file != null) {
        await getProfile();
        Utils.saveStringValue(
            "image", _userDetails.studentData?.user?.studentPhoto ?? '');
      }
    } catch (e) {
      Utils.showToast('Failed to update profile');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future pickDocument() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [AndroidUiSettings(toolbarTitle: 'Cropper')],
      );
      if (croppedFile != null) setState(() => _file = File(croppedFile.path));
    } else {
      Utils.showToast('Cancelled');
    }
  }

  Future saveAll() async {
    if (_formKey.currentState?.validate() ?? false) {
      await updateData(fieldName: 'first_name', value: _firstNameCtrl.text);
      await updateData(fieldName: 'last_name', value: _lastNameCtrl.text);
      await updateData(fieldName: 'current_address', value: _addressCtrl.text);
      await updateData(fieldName: 'date_of_birth', value: _dobController.text);
      if (_file != null) await updateData(fieldName: 'student_photo');
      Utils.showToast('Profile updated successfully');
      Navigator.of(context).pop(widget.updateData!(1));
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile().then((value) {
      setState(() {
        _firstNameCtrl.text = value.studentData?.user?.firstName ?? '';
        _lastNameCtrl.text = value.studentData?.user?.lastName ?? '';
        _addressCtrl.text = value.studentData?.user?.currentAddress ?? '';

        // Handle the date parsing safely
        String dob = value.studentData?.user?.dateOfBirth ?? '';
        try {
          date = DateTime.parse(dob);
          _dobController.text = "${date?.day}/${date?.month}/${date?.year}";
        } catch (e) {
          // Handle invalid date format
          print('Invalid date format: $dob');
          _dobController.text =
              ''; // Set a default value if the date format is invalid
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(title: 'Edit Profile'),
      body: _isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      buildTextField('First Name', _firstNameCtrl),
                      buildTextField('Last Name', _lastNameCtrl),
                      buildTextField('Address', _addressCtrl),
                      buildDateField(context),
                      buildProfilePhoto(),
                      h8,
                      // ElevatedButton(
                      //   onPressed: saveAll,
                      //   child: const Text('Save'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: saveAll,
          child: Container(
            width: screenWidth(360, context),
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Utils.baseBlue),
            child: const Center(
                child: Text(
              'Save Changes',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            )),
          ),
        ),
      ),
    );
  }

  Widget buildProfilePhoto() {
    return Column(
      children: [
        InkWell(
          onTap: pickDocument,
          child: Container(
            width: screenWidth(390, context),
            //  height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _file == null
                        ? 'Select Image'
                        : _file?.path.split('/').last ?? '',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.start,
                  ),
                  if (_file != null) h8,
                  _file == null
                      ? const SizedBox.shrink()
                      : Image.file(_file!, width: 100, height: 100),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          // Default border when not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          // Border when focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
        ),
        validator: (value) =>
            value?.isEmpty == true ? 'Please enter $label' : null,
      ),
    );
  }

  Widget buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          DatePicker.showDatePicker(
            context,
            onConfirm: (dateTime, _) {
              setState(() {
                date = dateTime;
                _selectedDate = '${date?.year}-${date?.month}-${date?.day}';
                _dobController.text = _selectedDate!;
              });
            },
          );
        },
        child: AbsorbPointer(
          child: TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              // Border when focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ),
    );
  }
}
