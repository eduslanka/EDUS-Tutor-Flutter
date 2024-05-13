import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/controller/system_controller.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomExpansionTileCard.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'views/bbb/bbb_virtual_class.dart';
import 'views/jitsi/jitsi_virtual_class.dart';
import 'views/zoom/zoom_virtual_class.dart';

class VirtualClassMain extends StatelessWidget {

  final SystemController systemController = Get.put(SystemController());

  final UserController userController = Get.put(UserController());

  VirtualClassMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Class",
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [

                systemController.systemSettings.value.data!.zoom!
                    ? CustomExpansionTileCard(
                        title: const Text("Zoom"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: [
                          ListTile(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const ZoomVirtualClass(
                                  type: 'class',
                                ),
                                withNavBar: false,
                              );
                            },
                            title: Text(
                              "Virtual Class",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ),
                          userController.role.value != "2"
                              ? ListTile(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const ZoomVirtualClass(
                                        type: 'meeting',
                                      ),
                                      withNavBar: false,
                                    );
                                  },
                                  title: Text(
                                    "Virtual Meeting",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 14),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 20,
                ),
                systemController.systemSettings.value.data!.bbb!
                    ? CustomExpansionTileCard(
                        title: const Text("BigblueButton"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: [
                          ListTile(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const BBBVirtualClass(type: "class"),
                                withNavBar: false,
                              );
                            },
                            title: Text(
                              "Virtual Class",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ),
                          userController.role.value != "2"
                              ? ListTile(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const BBBVirtualClass(type: "meeting"),
                                      withNavBar: false,
                                    );
                                  },
                                  title: Text(
                                    "Virtual Meeting",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 14),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  height: 20,
                ),
                systemController.systemSettings.value.data!.jitsi!
                    ? CustomExpansionTileCard(
                        title: const Text("Jitsi"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                        children: [
                          ListTile(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: const JitsiVirtualClass(type: "class"),
                                withNavBar: false,
                              );
                            },
                            title: Text(
                              "Virtual Class",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 14),
                            ),
                          ),
                          userController.role.value != "2"
                              ? ListTile(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen:
                                          const JitsiVirtualClass(type: "meeting"),
                                      withNavBar: false,
                                    );
                                  },
                                  title: Text(
                                    "Virtual Meeting",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontSize: 14),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox.shrink(),


                if(!systemController.systemSettings.value.data!.zoom! && !systemController.systemSettings.value.data!.bbb! &&  !systemController.systemSettings.value.data!.jitsi!)
                 const Center(
                    child: Text(
                      'Class no available',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.pinkAccent, fontSize: 24.0),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
