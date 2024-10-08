// 🐦 Flutter imports:

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/exception/DioException.dart';
import 'package:edus_tutor/utils/model/Route.dart';
import 'package:edus_tutor/utils/model/Vehicle.dart';

// 📦 Package imports

// ignore: must_be_immutable
class AssignVehicle extends StatefulWidget {
  const AssignVehicle({super.key});

  @override
  _AssignVehicleState createState() => _AssignVehicleState();
}

class _AssignVehicleState extends State<AssignVehicle> {
  TextEditingController titleController = TextEditingController();

  TextEditingController fareController = TextEditingController();

  String _token = '';
  String id = '';

  Response? response;

  Dio dio = Dio();

  Future<VehicleRouteList>? getRoute;

  Future<AssignVehicleList>? getVehicle;

  String? selectedRoute;
  dynamic selectedRouteId;

  String? selectedVehicle;
  dynamic selectedVehicleId;

  bool isResponse = false;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    }).then((value) {
      setState(() {
        Utils.getStringValue('id').then((value) {
          id = value ?? '';
        });
        getRoute = getRouteList();
        getRoute?.then((value) {
          selectedRoute = value.routes[0].title;
          selectedRouteId = value.routes[0].id;
        });

        getVehicle = getAllVehicles();
        getVehicle?.then((value) {
          selectedVehicle = value.assignVehicle[0].vehicleNo;
          selectedVehicleId = value.assignVehicle[0].id;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Assign Vehicle to Route',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Route'.tr,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
              ),
            ),
            FutureBuilder<VehicleRouteList>(
                future: getRoute,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.routes.isNotEmpty) {
                      return getRouteDropDown(snapshot.data?.routes ?? []);
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Vehicle'.tr,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(),
              ),
            ),
            FutureBuilder<AssignVehicleList>(
                future: getVehicle,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.assignVehicle.isNotEmpty) {
                      return getVehicleDropDown(
                          snapshot.data?.assignVehicle ?? []);
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: assignVehicle,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                decoration: Utils.gradientBtnDecoration,
                child: Text(
                  "Save".tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isResponse == true
                  ? const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                    )
                  : const Text(''),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRouteDropDown(List<VehicleRoute> routes) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: routes.map((item) {
          return DropdownMenuItem<String>(
            value: item.title,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.title ?? '',
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
            selectedRoute = value.toString();
            selectedRouteId = getCode(routes, value.toString());
          });
        },
        value: selectedRoute,
      ),
    );
  }

  Widget getVehicleDropDown(List<Vehicle> vehicles) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: vehicles.map((item) {
          return DropdownMenuItem<String>(
            value: item.vehicleNo,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 10.0),
              child: Text(
                item.vehicleNo ?? '',
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
            selectedVehicle = value.toString();
            selectedVehicleId = getCode2(vehicles, value.toString());
          });
        },
        value: selectedVehicle,
      ),
    );
  }

  int? getCode<T>(List<VehicleRoute> t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.title == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  int? getCode2<T>(List<Vehicle> t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.vehicleNo == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  // ignore: missing_return
  Future<VehicleRouteList> getRouteList() async {
    final response = await http.get(Uri.parse(EdusApi.transportRoute),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return VehicleRouteList.fromJson(data['data']);
    } else {
      return VehicleRouteList([]);
    }
  }

  Future<AssignVehicleList> getAllVehicles() async {
    final response = await http.get(Uri.parse(EdusApi.vehicles),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AssignVehicleList.fromJson(jsonData['data']['assign_vehicles']);
    } else {
      throw Exception('Failed to load');
    }
  }

  assignVehicle() async {
    setState(() {
      isResponse = true;
    });
    FormData formData = FormData.fromMap({
      "route": selectedRouteId,
      "vehicles[]": [selectedVehicleId],
    });

    response = await dio
        .post(
      EdusApi.assignVehicle,
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
      setState(() {
        isResponse = false;
      });
      Utils.showToast('Already Assigned');
      Utils.showToast(errorMessage);
    });

    if (response?.statusCode == 200) {
      Utils.showToast('$selectedVehicle ${'assigned to'.tr} $selectedRoute');
      setState(() {
        isResponse = false;
      });
      return true;
    } else if (response?.statusCode == 404) {
      setState(() {
        isResponse = false;
      });
      if (response?.data['success'] == false) {
        Utils.showToast(
            '$selectedVehicle ${'already assigned to'.tr} $selectedRoute');
      }
      return true;
    } else {
      return false;
    }
  }
}
