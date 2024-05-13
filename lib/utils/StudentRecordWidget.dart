import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentRecordWidget extends StatelessWidget {
  final ValueChanged<Record>? onTap;
  StudentRecordWidget({Key? key, this.onTap}) : super(key: key);

  final UserController _userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      alignment: Alignment.center,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemBuilder: (context, recordIndex) {
          Record record =
              _userController.studentRecord.value.records?[recordIndex] ?? Record();
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              onTap!(record);
            },
            child: Container(
              height: 25,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: _userController.selectedRecord.value == record
                      ? Colors.transparent
                      : Colors.grey,
                ),
                gradient: _userController.selectedRecord.value == record
                    ? const LinearGradient(
                        colors: [
                          Color(0xff7C32FF),
                          Color(0xffC738D8),
                        ],
                      )
                    : const LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ),
              ),
              child: Text(
                "${record.className} (${record.sectionName})",
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontSize: 14,
                  color: _userController.selectedRecord.value == record
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          );
        },
        itemCount: _userController.studentRecord.value.records?.length ?? 0,
      ),
    );
  }
}
