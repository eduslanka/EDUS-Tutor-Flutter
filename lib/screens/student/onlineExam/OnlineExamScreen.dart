// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/controller/system_controller.dart';

// Project imports:
import 'package:edus_tutor/utils/CardItem.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';

// ignore: must_be_immutable
class OnlineExaminationHome extends StatefulWidget {
  final _titles;
  final _images;
  var id;

  OnlineExaminationHome(this._titles, this._images, {super.key, this.id});

  @override
  _HomeState createState() => _HomeState(_titles, _images);
}

class _HomeState extends State<OnlineExaminationHome> {
  bool? isTapped;
  int? currentSelectedIndex;
  final _titles;
  final _images;

  _HomeState(this._titles, this._images);

  final SystemController _systemController = Get.put(SystemController());
  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Online Exam'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;

                  if (_systemController.systemSettings.value.data?.onlineExam ==
                      false) {
                    AppFunction.getOnlineExaminationDashboardPage(
                        context, _titles[index],
                        id: widget.id);
                  } else {
                    AppFunction.getOnlineExaminationModuleDashboardPage(
                        context, _titles[index],
                        id: widget.id);
                  }
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
