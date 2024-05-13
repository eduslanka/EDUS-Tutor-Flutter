import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/student/onlineExam/module/controller/ExamController.dart';
import 'package:infixedu/screens/student/onlineExam/module/controller/OnlineExamController.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/model/StudentRecord.dart';

import '../model/ActiveOnlineModel.dart';
import 'TakeExamScreen.dart';

class ActiveOnlineExams extends StatefulWidget {
  final id;

  const ActiveOnlineExams({Key? key, this.id}) : super(key: key);

  @override
  _ActiveOnlineExamsState createState() => _ActiveOnlineExamsState(id: id);
}

class _ActiveOnlineExamsState extends State<ActiveOnlineExams> {
  final ExamController _examCtrl = Get.put(ExamController());
  final UserController _userController = Get.put(UserController());

  var id;

  _ActiveOnlineExamsState({this.id});

  @override
  void initState() {
    _userController.selectedRecord.value =
        _userController.studentRecord.value.records?.first ?? Record();

    Utils.getStringValue('id').then((value) async {
      id = id ?? value;
      await _examCtrl.getAllActiveExam(
          id, _userController.studentRecord.value.records?.first.id ?? 0);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Active Exam'),
      backgroundColor: Colors.white,
      body: getExamList(),
    );
  }

  Widget getExamList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              shrinkWrap: true,
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
                  onTap: () async {
                    _userController.selectedRecord.value = record;
                    await _examCtrl.getAllActiveExam(id, record.id ?? 0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
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
                      style: Get.textTheme.titleMedium?.copyWith(
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
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Obx(() {
              if (_examCtrl.exams.value.data == null) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else {
                if (_examCtrl.isLoading.value) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  if (_examCtrl.exams.value.data!.onlineExams!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _examCtrl.exams.value.data?.onlineExams?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ActiveOnlineExamRow(
                          status: _examCtrl
                              .exams.value.data?.onlineExams?[index].status ?? '',
                          exam: _examCtrl.exams.value.data?.onlineExams?[index] ?? OnlineExam(),
                          recordId: _userController.selectedRecord.value.id,
                        );
                      },
                    );
                  } else {
                    return Utils.noDataWidget();
                  }
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}

class ActiveOnlineExamRow extends StatefulWidget {
  final OnlineExam? exam;
  final String? status;
  final int? recordId;

  const ActiveOnlineExamRow({Key? key, 
    this.exam,
    this.status,
    this.recordId,
  }) : super(key: key);

  @override
  State<ActiveOnlineExamRow> createState() => _ActiveOnlineExamRowState();
}

class _ActiveOnlineExamRowState extends State<ActiveOnlineExamRow> {
  final OnlineExamController _onlineExamController =
      Get.put(OnlineExamController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.exam?.title ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: ScreenUtil().setSp(15.0)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Subject'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.exam?.subject ?? '',
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${widget.exam?.startDate}" +
                              " (${widget.exam?.startTime})",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'End'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${widget.exam?.endDate}" +
                              " (${widget.exam?.endTime})",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Action'.tr,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        getStatus(context, widget.status ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.5,
              margin: const EdgeInsets.only(top: 10.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.purple, Colors.deepPurple]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getStatus(BuildContext context, String status) {
    if (status == "waiting") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.amber.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Waiting'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else if (status == "take_exam") {
      return InkWell(
        onTap: () {
          Get.defaultDialog(
            title: "Start Exam".tr,
            backgroundColor: Get.theme.cardColor,
            titleStyle: Get.textTheme.titleMedium,
            barrierDismissible: true,
            content: Column(
              children: [
                Text(
                  "Do you want to start the exam?".tr,
                  style: Get.textTheme.titleSmall?.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: 100,
                        height: MediaQuery.of(context).size.height / 100 * 5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Cancel".tr,
                          style: Get.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Obx(() {
                      return _onlineExamController.isQuizStarting.value
                          ? Container(
                              width: 100,
                              height:
                                  MediaQuery.of(context).size.height / 100 * 5,
                              alignment: Alignment.center,
                              child: const CupertinoActivityIndicator())
                          : Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff7C32FF),
                                    Color(0xffC738D8),
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  // elevation: MaterialStateProperty.all(3),
                                  shadowColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                onPressed: () async {
                                  await _onlineExamController
                                      .startQuiz(
                                          widget.exam?.id,
                                          widget.recordId,
                                          _onlineExamController
                                              .userController.schoolId.value)
                                      .then((value) {
                                    if (value != null) {
                                      Get.back();
                                      Get.to(() => TakeExamScreen(
                                            takeExamModel: value,
                                          ));
                                    } else {
                                      CustomSnackBar().snackBarError(
                                          "Error starting exam.".tr);
                                    }
                                  });
                                },
                                child: Text(
                                  "Start".tr,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffffffff),
                                      height: 1.3,
                                      fontFamily: 'AvenirNext'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                    }),
                  ],
                ),
              ],
            ),
            radius: 5,
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.green.shade500),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Take Exam'.tr,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      );
    } else if (status == "answer_script") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.indigo.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Submitted'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else if (status == "closed") {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.red.shade500),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Closed'.tr,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
