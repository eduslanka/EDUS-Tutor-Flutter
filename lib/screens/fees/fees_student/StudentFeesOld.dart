import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/utils/StudentRecordWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/screens/fees/services/FeesService.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:infixedu/utils/server/LogoutService.dart';
import 'package:infixedu/screens/fees/widgets/Fees_row_layout.dart';
import 'package:infixedu/utils/widget/ShimmerListWidget.dart';

class StudentFeesOld extends StatefulWidget {
  final String? id;

  const StudentFeesOld({Key? key, this.id}) : super(key: key);
  @override
  _StudentFeesOldState createState() => _StudentFeesOldState();
}

class _StudentFeesOldState extends State<StudentFeesOld> {
  final UserController _userController = Get.put(UserController());
  String? _token = '';

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConfig.appToolbarBackground),
                fit: BoxFit.fill,
              ),
              color: Colors.deepPurple,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 25.w,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "Fees".tr,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: () {
                    Get.dialog(LogoutService().logoutDialog());
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          StudentRecordWidget(
            onTap: (Record record) async {
              _userController.selectedRecord.value = record;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Grand Total'.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: FutureBuilder(
              future: Utils.getStringValue('id'),
              builder: (context, id) {
                if (id.hasData) {
                  return StreamBuilder<List<double>>(
                      stream: Stream.periodic(const Duration(seconds: 5))
                          .asyncMap((i) => FeeService(
                                int.parse(widget.id.toString() ?? id.data.toString()),
                                _token ?? '',
                              ).fetchTotalFee()),
                      builder: (context, totalSnapshot) {
                        if (totalSnapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Amount'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      totalSnapshot.data?[0].toString() ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Discount'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      totalSnapshot.data?[1].toString() ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Fine'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      totalSnapshot.data?[2].toString() ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Paid'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      totalSnapshot.data?[3].toString() ?? '',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Balance'.tr,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      totalSnapshot.data?[4].toString() ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ShimmerList(
                            height: 40,
                            itemCount: 1,
                          );
                        }
                      });
                } else {
                  return const Text('...');
                }
              },
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 15.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xffd9c1f8).withOpacity(0.5), Colors.white]),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: Utils.getStringValue('id'),
                builder: (context, snapId) {
                  if (snapId.hasData) {
                    return StreamBuilder<List<FeeElement>>(
                        stream: Stream.periodic(const Duration(seconds: 5))
                            .asyncMap((i) => FeeService(
                                  int.parse(widget.id ?? snapId.data.toString()),
                                  _token ?? '',
                                ).fetchFee()),
                        // future: FeeService(int.parse(
                        //     widget.id != null ? widget.id : snapId.data),_token,int.parse(_schoolId))
                        //     .fetchFee(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return FeesRow(
                                      snapshot.data?[index] ?? FeeElement(),
                                      widget.id ?? snapId.data.toString());
                                });
                          } else {
                            return ShimmerList(
                              height: 40,
                              itemCount: 1,
                            );
                          }
                        });
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
