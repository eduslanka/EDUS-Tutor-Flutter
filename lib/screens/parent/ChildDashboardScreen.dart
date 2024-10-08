// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:edus_tutor/config/app_config.dart';

import 'package:edus_tutor/utils/CardItem.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';
import 'package:edus_tutor/utils/server/LogoutService.dart';

import '../../controller/system_controller.dart';

// ignore: must_be_immutable
class ChildHome extends StatefulWidget {
  final _titles;
  final _images;
  dynamic id;
  String profileImage;
  String token;
  String name;

  ChildHome(this._titles, this._images, this.id, this.profileImage, this.token,
      this.name,
      {super.key});

  @override
  _ChildHomeState createState() =>
      _ChildHomeState(_titles, _images, token, name);
}

class _ChildHomeState extends State<ChildHome> {
  bool? isTapped;
  dynamic currentSelectedIndex;
  final _titles;
  final _images;
  final String _token;
  final String _name;

  _ChildHomeState(this._titles, this._images, this._token, this._name);

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  final SystemController _systemController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            height: 100.h,
            padding: EdgeInsets.only(top: 20.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConfig.appToolbarBackground),
                fit: BoxFit.cover,
              ),
              color: const Color(0xff053EFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 70.h,
                    width: 70.w,
                    child: IconButton(
                        tooltip: 'Back',
                        icon: Icon(
                          Icons.arrow_back,
                          size: ScreenUtil().setSp(20),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        }),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      "$_name ${"Dashboard".tr}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            if (_titles[index] == "Class") {
              return const SizedBox.shrink();
            }
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;

                  AppFunction.getDashboardPage(context, _titles[index],
                      id: widget.id.toString(),
                      image: widget.profileImage,
                      token: _token);
                });
              },
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}

//Future<String> getImageUrl(String email, String password, String rule) async {
//  var image = 'https://i.imgur.com/BoN9kdC.png';
//
//  var response = await http.get(InfixApi.login(email, password));
//
//  if (response.statusCode == 200) {
//    Map<String, dynamic> user = jsonDecode(response.body) as Map;
//
//    if (rule == '2')
//      image = InfixApi.root + user['data']['userDetails']['student_photo'];
//    else
//      image = InfixApi.root + user['data']['userDetails']['staff_photo'];
//  }
//  return '$image';
//}

void navigateToPreviousPage(BuildContext context) {
  Navigator.pop(context);
}
