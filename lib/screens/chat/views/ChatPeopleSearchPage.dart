import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/screens/chat/controller/chat_controller.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/screens/chat/models/ChatActiveStatus.dart';
import 'package:edus_tutor/screens/chat/models/ChatUser.dart';
import 'package:edus_tutor/screens/chat/views/Single/ChatOpenPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatPeopleSearchPage extends StatefulWidget {
  const ChatPeopleSearchPage({super.key});

  @override
  _ChatPeopleSearchPageState createState() => _ChatPeopleSearchPageState();
}

class _ChatPeopleSearchPageState extends State<ChatPeopleSearchPage> {
  final TextEditingController searchController = TextEditingController();

  final ChatController _chatController = Get.put(ChatController());

  Timer? debounce;

  bool search = false;

  _onSearchChanged(String text) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 1000), () async {
      if (text != '') {
        _chatController.searchClicked.value = true;
        await _chatController.searchUser(text);
      } else {
        _chatController.searchClicked.value = false;
        _chatController.searchUserModel.value.users = null;
      }
    });
  }

  getStatusColor(ChatStatus chatStatus) {
    if (chatStatus.status == 0) {
      return Colors.grey;
    } else if (chatStatus.status == 1) {
      return Colors.green;
    } else if (chatStatus.status == 2) {
      return Colors.amber;
    } else if (chatStatus.status == 3) {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry customPadding =
        const EdgeInsets.symmetric(horizontal: 15, vertical: 10);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Search user",
      ),
      body: Column(
        children: [
          Padding(
            padding: customPadding,
            child: TextFormField(
              keyboardType: TextInputType.text,
              style: Theme.of(context).textTheme.titleLarge,
              controller: searchController,
              autovalidateMode: AutovalidateMode.disabled,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search by name or email",
                labelText: "Search by name or email",
                labelStyle: Theme.of(context).textTheme.titleLarge,
                errorStyle: const TextStyle(color: Colors.blue, fontSize: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  size: 24,
                  color: Color.fromRGBO(142, 153, 183, 0.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (_chatController.searchClicked.value) {
                  if (_chatController.isSearching.value) {
                    return const CupertinoActivityIndicator();
                  } else {
                    if (_chatController.searchUserModel.value.users == null) {
                      return Center(
                        child: Text(
                          "Search for users",
                          style: Get.textTheme.titleMedium,
                        ),
                      );
                    } else {
                      if (_chatController
                          .searchUserModel.value.users!.isNotEmpty) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          shrinkWrap: true,
                          itemCount: _chatController
                                  .searchUserModel.value.users?.length ??
                              0,
                          itemBuilder: (context, searchIndex) {
                            ChatUser chatUser = _chatController.searchUserModel
                                    .value.users?[searchIndex] ??
                                ChatUser();
                            return ListTile(
                              onTap: () async {
                                await _chatController
                                    .invitation(chatUser.id)
                                    .then((value) {
                                  Get.to(() => ChatOpenPage(
                                      avatarUrl: chatUser.avatarUrl ?? '',
                                      userId: chatUser.id ?? 0,
                                      onlineStatus: int.tryParse(chatUser
                                              .activeStatus
                                              .toString()) ??
                                          0,
                                      chatTitle: chatUser.fullName ??
                                          chatUser.username.toString()));
                                });
                              },
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: CachedNetworkImage(
                                imageUrl: chatUser.avatarUrl == null ||
                                        chatUser.avatarUrl == ""
                                    ? "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg"
                                    : '${AppConfig.domainName}/${chatUser.avatarUrl}',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg"),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "${AppConfig.domainName}/public/uploads/staff/demo/staff.jpg"),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    chatUser.fullName ?? chatUser.email ?? "",
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: ChatUser().getOnlineColor(
                                          chatUser.activeStatus),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No user found",
                            style: Get.textTheme.titleMedium,
                          ),
                        );
                      }
                    }
                  }
                } else {
                  return Center(
                    child: Text(
                      "Search for users",
                      style: Get.textTheme.titleMedium,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
