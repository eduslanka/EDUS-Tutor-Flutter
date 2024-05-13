import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' as GETx;
import 'package:infixedu/screens/chat/controller/chat_open_controller.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/chat/models/ChatMessage.dart';
import 'package:infixedu/screens/chat/models/ChatMessageOpenModel.dart';
import 'package:loading_more_list/loading_more_list.dart';

import '../../controller/chat_controller.dart';

class ChatLoadMore extends LoadingMoreBase<ChatMessage> {
  final int userId;
  ChatLoadMore(this.userId, this.chatOpenController);
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;
  dynamic source;

  final ChatOpenController chatOpenController;

  final ChatController _chatController = GETx.Get.put(ChatController());

  final Dio _dio = Dio();

  @override
  bool get hasMore => _hasMore;

  @override
  void onStateChanged(LoadingMoreBase<ChatMessage> source) {
    super.onStateChanged(source);
  }

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    // pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      await chatOpenController.getIdToken();
      Response result;

      if (isEmpty) {
        result = await _dio
            .get(
          "${InfixApi.getChatOpen}/$userId",
          options: Options(
            headers: Utils.setHeader(chatOpenController.token.value.toString()),
          ),
        )
            .catchError((onError) {
          isSuccess = false;
          length = 0;
        });
      } else {
        result = await _dio
            .post(
          InfixApi.chatMsgLoadMore,
          data: jsonEncode(
            {
              "ids": chatOpenController.msgIds.toSet().toList().toString(),
              "user_id": userId,
            },
          ),
          options: Options(
            headers: Utils.setHeader(chatOpenController.token.value.toString()),
          ),
        )
            .catchError((onError) {
          isSuccess = false;
          length = 0;
        });
      }
      if (result.statusCode == 200) {
        final data = Map<String, dynamic>.from(result.data);

        if (isEmpty) {
          source = ChatMessageOpenModel.fromJson(data);
          if (source.messages.length == 0) {
            length = 0;

            if (_chatController.chatSettings.value.chatSettings?.chatMethod !=
                "pusher") {
              chatOpenController.lastConversationId.value = 0;
            }
          } else {
            if (source.messages.length != 1) {
              if (_chatController.chatSettings.value.chatSettings?.chatMethod !=
                  "pusher") {
                chatOpenController.lastConversationId.value =
                    source.messages.entries.first.value.id;
              }
            } else {
              if (_chatController.chatSettings.value.chatSettings?.chatMethod !=
                  "pusher") {
                chatOpenController.lastConversationId.value =
                    source.messages.first.id;
              }
            }
          }
        } else {
          source = ChatLoadMoreModel.fromJson(data);
        }
        if (source.messages != null && source.messages.length != 0) {
          if (source.messages.length != 1) {
            productsLength = source.messages.length;

            source.messages.forEach((key, value) {
              chatOpenController.msgIds.add(value.id);
            });

            if (pageIndex == 1) {
              clear();
            }
            for (var item in source.messages.entries) {
              add(item.value);
            }
          } else {
            productsLength = source.messages.length;

            source.messages.forEach((value) {
              chatOpenController.msgIds.add(value.id);
            });

            if (pageIndex == 1) {
              clear();
            }
            for (var item in source.messages) {
              add(item);
            }
          }
        }

        if (source.messages != null) {
          _hasMore = true;
        } else {
          _hasMore = false;
        }
      } else {
        length = 0;
      }
      pageIndex++;
      isSuccess = true;
    } catch (exception, _) {
      if (exception is DioError) {
        if (exception.response?.statusCode == 404) {
          length = 0;
        }
      }
      isSuccess = false;
    }
    return isSuccess;
  }

  Future checkNewMsg() async {
    ChatMessageOpenModel data;
    try {
      Map jsonData = {
        "user_id": userId,
        "last_conversation_id": chatOpenController.lastConversationId.value,
      };
      final response = await _dio.post(
        InfixApi.newChatMsgCheck,
        options: Options(
          headers: Utils.setHeader(chatOpenController.token.toString()),
        ),
        data: jsonEncode(jsonData),
      );
      final msgCheckResultData = Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200) {
        // print(msgCheckResultData['message']);


        data = ChatMessageOpenModel.fromJson(response.data);
        insert(0, data.messages.entries.first.value);

        chatOpenController.msgIds
            .insert(0, data.messages.entries.first.value.id);
        chatOpenController.lastConversationId.value =
            data.messages.entries.first.value.id;
        onStateChanged(this);

        // await chatGroupOpenController.getAll();
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {

    }
  }

  Future deleteSingleMessage(ChatMessage chatMessage) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      Map jsonData = {
        "conversation_id": chatMessage.id,
        "user_id": userId,
      };


      final response = await _dio.post(
        InfixApi.chatSingleMsgDelete,
        options: Options(
          headers: Utils.setHeader(chatOpenController.token.toString()),
        ),
        data: jsonEncode(jsonData),
      );

      final msgCheckResultData = Map<String, dynamic>.from(response.data);

      if (response.statusCode == 200) {

        chatOpenController.msgIds.remove(chatMessage.id);

        remove(chatMessage);

        chatOpenController.lastConversationId.value =
            chatOpenController.msgIds.first;
        onStateChanged(this);
      } else {
        throw Exception('failed to load');
      }
    } catch (e) {
      // throw Exception('${e.toString()}');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future submitText({Map? data, bool? hasFile, FormData? formData}) async {
    EasyLoading.show();
    try {
      final response = await _dio.post(
        InfixApi.submitChatText,
        options: Options(
          headers: Utils.setHeader(chatOpenController.token.toString()),
        ),
        data: hasFile! ? formData : jsonEncode(data),
      );
      if (response.statusCode == 200) {
        if (_chatController.chatSettings.value.chatSettings?.chatMethod !=
            'pusher') {
          var chatMessage = ChatMessage.fromJson(response.data['message']);

          if (chatOpenController.lastConversationId.value == null) {
            chatOpenController.msgIds.add(chatMessage.id);
            insert(0, chatMessage);
            onStateChanged(this);
            chatOpenController.lastConversationId.value = chatMessage.id;
          }
        }
        if (_chatController.chatSettings.value.chatSettings?.chatMethod ==
                'pusher' &&
            isEmpty) {
          var chatMessage = ChatMessage.fromJson(response.data['message']);
          chatOpenController.msgIds.add(chatMessage.id);
          insert(0, chatMessage);
          onStateChanged(this);
        }

        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        throw Exception('failed to load');
      }
    } catch (e) {
      EasyLoading.dismiss();
      throw Exception(e.toString());
    } finally {}
  }
}
