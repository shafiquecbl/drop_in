import 'dart:convert';

import 'package:dropin/src/models/chat_model2.dart';
import 'package:dropin/src/service/network_service.dart';
import 'package:dropin/src_exports.dart';
import '../../models/chat_details_model.dart';
import '../../models/news_feed_model.dart';

class ChatScreenController extends BaseController {
  //Mic Toggle
  RxBool isEdit = false.obs;
  RxList<NewsFeedModel> newsFeedList = <NewsFeedModel>[].obs;
  RxList<ChatDetailsModel> chatlist = <ChatDetailsModel>[].obs;
  RxList<ChatDetailsModel> businessChatList = <ChatDetailsModel>[].obs;

  @override
  void onInit() {
    getChatList();
    getChatList(false);
    super.onInit();
  }

  Future<void> getChatList([bool isUser = true]) async {
    try {
      Map<String, dynamic> params = {
        'type': isUser ? 1 : 2,
        'id': app.user.id,
      };
      onUpdate(status: Status.LOADING);
      ResponseModel res = await net.get(UrlConst.getChat, params);
      if (res.isSuccess) {
        if (isUser) {
          chatlist.value = List<ChatDetailsModel>.from(
            (res.data ?? []).map(
                  (e) => ChatDetailsModel.fromJson(e),
            ),
          );
        } else {
          businessChatList.value = List<ChatDetailsModel>.from(
            (res.data ?? []).map(
                  (e) => ChatDetailsModel.fromJson(e),
            ),
          );
        }
        logger.w('CHATLIST::${chatlist.value.length}---${businessChatList.value
            .length}');
        chatlist.value.forEach((element) {
          logger.wtf('SINGLE CHAT::::${element.toJson()}');
        });
        businessChatList.value.forEach((element) {
          logger.wtf('SINGLE BUSINESS CHAT::::${element.toJson()}');
        });
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e, getChatList);
    }
  }

  Future<void> chatLike({required ChatModel chat}) async {
    try {
      logger.w(chat.isChatLiked);
      Map<String, dynamic> params = {
        'from_user': app.user.id,
        'to_user': chat.user.id,
      };
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(chat.chatID)
          .update(
        {
          'isChatLiked': !chat.isChatLiked,
        },
      );

      ResponseModel res = await net.post(UrlConst.userLike, params);
      chat.isChatLiked = !chat.isChatLiked;
      if (res.isFailed) {
        throw res.message;
      }
    } catch (e) {
      onError(
        e,
            () {
          chatLike(chat: chat);
        },
      );
    }
  }

  Future<void> reportUser({
    required ChatModel chat,
    required String reason,
  }) async {
    try {
      onUpdate(status: Status.LOADING_MORE);

      ResponseModel response = await net.post(
        UrlConst.reportuser,
        {
          'to_user': chat.user.id,
          'reason': reason,
        },
      );
      if (response.isSuccess) {
        FirebaseFirestore.instance.collection('chat').doc('${chat.chatID}').set(
          {
            'users': FieldValue.arrayRemove(
              [
                jsonEncode({
                  'isBusiness': false,
                  'id': app.user.id.toString(),
                }),
                jsonEncode({
                  'isBusiness': chat.user.isBusiness,
                  'id': chat.user.id.toString(),
                })
              ],
            ),
          },
          SetOptions(merge: true),
        );

        onUpdate(status: Status.SCUSSESS);
      } else {
        throw response.message;
      }
    } catch (e) {
      onError(
        e.toString(),
            () {
          reportUser(chat: chat, reason: reason);
        },
      );
    }
  }
}
