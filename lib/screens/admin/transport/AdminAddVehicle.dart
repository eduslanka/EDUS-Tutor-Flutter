import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Staff.dart';
import 'package:infixedu/utils/model/Vehicle.dart';
import 'package:infixedu/utils/widget/Line.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({Key? key}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController vehicleNoController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController yearMadeModelController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  Future<StaffList>? staffs;
  Response? response;
  Dio dio = Dio();
  Future<AssignVehicleList>? vehicles;

  String? selectedDriver;
  dynamic selectedId;
  String? _token;
  bool staffFound = false;

  static List<Tab> tabs = <Tab>[
    Tab(
      text: 'Add Vehicle'.tr,
    ),
    Tab(
      text: 'Vehicle List'.tr,
    ),
  ];

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
      vehicles = getAllVehicles();
      staffs = getAllStaff();
      staffs?.then((staffVal) {
        setState(() {
          if (staffVal.staffs.length < 0) {
            staffFound = false;
          } else {
            staffFound = true;
            selectedDriver = staffVal.staffs[0].name;
            selectedId = staffVal.staffs[0].id;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(
        title: 'Add Vehicle',
      ),
      body: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: DefaultTabController(
          length: tabs.length,
          initialIndex: 0,
          child: Builder(
            builder: (context) {
              final TabController tabController =
                  DefaultTabController.of(context);
              tabController.addListener(() {
                if (tabController.indexIsChanging) {
                  setState(() {
                    vehicles = getAllVehicles();
                  });
                }
              });
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: TabBar(
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: Colors.purple,
                    tabs: tabs,
                    indicatorPadding: EdgeInsets.zero,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: TabBarView(
                    children: [
                      addVehicle(),
                      vehicleList(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget vehicleList() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Model'.tr,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  'Number'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  'Made Year'.tr,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: Text(
                  'Note'.tr,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<AssignVehicleList>(
                future: vehicles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.assignVehicle.isNotEmpty) {
                      return ListView.separated(
                          itemCount: snapshot.data?.assignVehicle.length ?? 0,
                          separatorBuilder: (context, index) {
                            return BottomLine();
                          },
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        snapshot.data?.assignVehicle[index]
                                            .vehicleModel ?? '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data?.assignVehicle[index].vehicleNo
                                            .toString() ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        snapshot
                                            .data?.assignVehicle[index].madeYear
                                            .toString() ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        snapshot.data?.assignVehicle[index].note ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          });
                    } else {
                      return Utils.noDataWidget();
                    }
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget addVehicle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: vehicleNoController,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: InputDecoration(hintText: 'Vehicle No'.tr),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: vehicleModelController,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: InputDecoration(hintText: 'Vehicle Model'.tr),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: yearMadeModelController,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: InputDecoration(hintText: 'Year Made'.tr),
            ),
          ),
          FutureBuilder<StaffList>(
            future: staffs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: getDriverDropdown(context, snapshot.data?.staffs ?? []),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: noteController,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: InputDecoration(hintText: 'Note'.tr),
            ),
          ),
          Expanded(child: Container()),
          staffFound
              ? Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onPressed: () {
                      addVehicleData(
                              vehicleNoController.text,
                              vehicleModelController.text,
                              '$selectedId',
                              noteController.text,
                              yearMadeModelController.text)
                          .then((value) {
                        if (value) {
                          vehicleNoController.text = '';
                          vehicleModelController.text = '';
                          noteController.text = '';
                          yearMadeModelController.text = '';
                        }
                      });
                    },
                    child: Text("Save".tr),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
        ],
      ),
    );
  }

  Widget getDriverDropdown(BuildContext context, List<Staff> driverList) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        items: driverList.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                item.name ?? '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 13.0),
        onChanged: (value) {
          setState(() {
            selectedDriver = value.toString();
            selectedId = getCode(driverList, value.toString());
          });
        },
        value: selectedDriver,
      ),
    );
  }

  Future<bool> addVehicleData(String vehicleNo, String model, String driverId,
      String note, String year) async {
    debugPrint(InfixApi.addVehicle(vehicleNo, model, driverId, note, year));
    response = await dio
        .post(
      InfixApi.addVehicle(vehicleNo, model, driverId, note, year),
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
      Utils.showToast('Vehicle Added'.tr);
      return true;
    } else {
      return false;
    }
  }

  int? getCode<T>(List<Staff> t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  Future<StaffList> getAllStaff() async {
    final response = await http.get(Uri.parse(InfixApi.driverList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return StaffList.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AssignVehicleList> getAllVehicles() async {
    final response = await http.get(Uri.parse(InfixApi.vehicles),
        headers: Utils.setHeader(_token.toString()));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return AssignVehicleList.fromJson(jsonData['data']['assign_vehicles']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
