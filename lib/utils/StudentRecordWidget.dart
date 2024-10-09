import 'package:edus_tutor/config/app_size.dart';
import 'package:edus_tutor/controller/user_controller.dart';
import 'package:edus_tutor/utils/model/StudentRecord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentRecordWidget extends StatelessWidget {
  final ValueChanged<Record>? onTap;
  StudentRecordWidget({super.key, this.onTap});

  final UserController _userController = Get.put(UserController());

  List<Widget> _buildRows(
      List<Record> records, int maxPerRow, BuildContext context) {
    List<Widget> rows = [];
    for (int i = 0; i < records.length; i += maxPerRow) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: records
              .sublist(
                  i,
                  i + maxPerRow > records.length
                      ? records.length
                      : i + maxPerRow)
              .map((record) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onTap!(record);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        alignment: Alignment.center,
                        //   padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color:
                                _userController.selectedRecord.value == record
                                    ? Colors.transparent
                                    : Colors.grey,
                          ),
                          gradient:
                              _userController.selectedRecord.value == record
                                  ? const LinearGradient(
                                      colors: [
                                        Colors.lightBlue,
                                        Color(0xff053EFF),
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                      ],
                                    ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            width: screenWidth(100, context),
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    '${record.className}',
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontSize: 12,
                                      color: _userController
                                                  .selectedRecord.value ==
                                              record
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    textAlign: TextAlign.center,
                                    '(${record.sectionName})',
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontSize: 10,
                                      color: _userController
                                                  .selectedRecord.value ==
                                              record
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Record> records = _userController.studentRecord.value.records ?? [];
    return Container(
      child: Column(
        children: _buildRows(records, 3, context),
      ),
    );
  }
}
