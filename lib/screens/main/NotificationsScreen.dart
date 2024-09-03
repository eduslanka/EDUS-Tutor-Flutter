import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/utils/server/LogoutService.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:edus_tutor/controller/notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  final String id;

  const NotificationScreen(this.id, {Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  Future readAll() async {
    print('function clicked');
    await controller.readNotification().then((value) {
      if (value == true) {
        controller.userNotificationList.value.userNotifications?.clear();
      }
    }).then((value) async {
      await controller.getNotifications();
    });
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
              decoration: const BoxDecoration(
                color: Color(0xff053EFF),
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
                        "Notification".tr,
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
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.getNotifications();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Obx(() {
                        return Text(
                          "You have".tr +
                              " ${controller.notificationCount.value} " +
                              "New notification".tr,
                        );
                      }),
                    ),
                    ElevatedButton(
                      onPressed: readAll,
                      child: Text(
                        'Mark all as read'.tr,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: ScreenUtil().setSp(12),
                                  color: Colors.white,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff053EFF),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (controller.userNotificationList.value.userNotifications!
                        .isEmpty) {
                      return Center(
                        child: Container(
                          child: Text(
                            "No new notifications".tr,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10.h,
                          );
                        },
                        itemCount: controller.userNotificationList.value
                                .userNotifications?.length ??
                            0,
                        itemBuilder: (context, index) {
                          final item = controller.userNotificationList.value
                              .userNotifications?[index];
                          return Dismissible(
                            key: Key(item?.id.toString() ?? ''),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: const Color(0xff053EFF),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Mark as Read'),
                                      content: const Text(
                                          'Are you sure you want to mark this notification as read?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Yes'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                return result ?? false;
                              }
                              return false;
                            },
                            onDismissed: (direction) async {
                              await controller
                                  .readNotification()
                                  .then((value) async {
                                if (value == true) {
                                  controller.userNotificationList.value
                                      .userNotifications
                                      ?.removeAt(index);
                                }
                              }).then((value) async {
                                await controller.getNotifications();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    FontAwesomeIcons.solidBell,
                                    color: const Color(0xff053EFF),
                                    size: 15.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item?.message.toString() ?? '',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontSize: ScreenUtil().setSp(13),
                                            ),
                                      ),
                                      Text(
                                        timeago.format(
                                            item?.createdAt ?? DateTime(2000)),
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontSize: ScreenUtil().setSp(12),
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                }),
              ),
            ],
          ),
        ));
  }
}
