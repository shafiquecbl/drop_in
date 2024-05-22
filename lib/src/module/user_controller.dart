import 'dart:convert';

import 'package:dropin/src/models/chat_details_model.dart';
import 'package:dropin/src/models/chat_model2.dart';
import 'package:dropin/src/utils/widgets/common_functions.dart';

import '../../src_exports.dart';
import '../service/network_service.dart';

class UserController extends BaseController {
  Rx<UserModel> user = UserModel().obs;
  String chatId = '0';

  @override
  void onInit() async {
    logger.w(Get.arguments);
    if (Get.arguments != null) {
      await getUserById();
      await createChat();
    }
    super.onInit();
  }

  Future<void> createChat() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> body = {
        'u_one': app.user.id,
        'u_two': user.value.id,
        'type': 1
      };
      ResponseModel response = await net.post(UrlConst.createChat, body);
      logger.wtf(response.toJson());
      if (response.isSuccess) {
        ChatDetailsModel detailedChat =
            ChatDetailsModel.fromJson(response.data ?? {});
        chatId = detailedChat.id.toString();
        detailedChat.user = user();
        ChatModel chatUser = ChatModel(
          chatID: '${detailedChat.id}',
          sender_id: app.user.id.toString(),
          message_type: 1,
          chatUser: detailedChat.user,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          last_message: '',
          isChatLiked: detailedChat.liked,
          users: <String>[
            jsonEncode({
              'isBusiness': false,
              'id': app.user.id.toString(),
            }),
            jsonEncode({
              'isBusiness': false,
              'id': user().id.toString(),
            }),
          ],
        );
        chatUser.user = detailedChat.user!;
        String messageDocID =
            FirebaseFirestore.instance.collection('messages').doc().id;
        MessageModel messageUser = MessageModel(
          created_at: DateTime.now(),
          sender_id: app.user.id.toString(),
          status: 1,
          message: '',
          message_type: 1,
        );

        if (response.message != 'chat_id already exist') {
          logger.v(
            'Adding data to chat\n doc -> ${'${response.data}'}\ndata -> ${chatUser.toJson()}',
          );
          await FirebaseFirestore.instance
              .collection('chat')
              .doc('${detailedChat.id}')
              .set(chatUser.toJson());
          // logger.v(
          //     'Adding data to chat\\message \n doc -> ${'${response.data}'}\ndata -> ${messageUser.toJson()}');
          // await FirebaseFirestore.instance
          //     .collection('chat')
          //     .doc('${detailedChat.id}')
          //     .collection('messages')
          //     .doc(messageDocID)
          //     .set(messageUser.toJson());
        }
        onUpdate(status: Status.SCUSSESS);
      } else {
        if (response.message == 'chat_id already exist') {
          chatId = '${response.data}';
          logger.w('chat id exists');
          ChatModel chatUser = ChatModel(
            chatID: '${response.data}',
            sender_id: app.user.id.toString(),
            message_type: 1,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            chatUser: user(),
            users: <String>[
              jsonEncode({
                'isBusiness': false,
                'id': app.user.id.toString(),
              }),
              jsonEncode({
                'isBusiness': false,
                'id': user().id.toString(),
              }),
            ],
          );

          await FirebaseFirestore.instance
              .collection('chat')
              .doc('${response.data}')
              .set(
                chatUser.toJson2(),
                SetOptions(merge: true),
              );
          ChatDetailsModel detailsModel = ChatDetailsModel(
            id: response.data,
            uOne: app.user.id,
            uTwo: user().id,
            user: user(),
            type: 1,
          );
          onUpdate(status: Status.SCUSSESS);
          return;
        } else {
          throw response.message;
        }
      }
    } catch (e) {
      onError(e.toString(), () {
        createChat();
      });
    }
  }

  Future<void> getUserById() async {
    try {
      onUpdate(status: Status.LOADING);
      Map<String, dynamic> params = {'id': Get.arguments ?? 0};
      ResponseModel res = await net.get(UrlConst.userGetById, params);
      if (res.isSuccess) {
        if (res.data is Map) {
          UserModel tempUser = UserModel.fromJson(res.data ?? {});
          logger.v(res.data);
          user.value = tempUser;
        }
        onUpdate(status: Status.SCUSSESS);
        // logger.wtf(app.user);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e.toString(), () {
        getUserById();
      });
    }
  }

  Future<void> userLike({required UserModel user}) async {
    try {
      Map<String, dynamic> params = {
        'from_user': app.user.id,
        'to_user': user.id,
      };
      // onUpdate(status: Status.LOADING);
      ResponseModel res = await net.post(UrlConst.userLike, params);
      if (res.isSuccess) {
        final foo = await FirebaseFirestore.instance
            .collection('chat')
            .doc(chatId)
            .update(
          {
            'isChatLiked': !user.is_like,
          },
        );
        user.is_like = !user.is_like;

        if (user.is_like) {
          logger.i(user.like_count);
          user.like_count++;
          logger.i(user.like_count);
        } else {
          user.like_count--;
        }
        onUpdate();
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(
        e,
        () {
          userLike(user: user);
        },
      );
    }
  }

  Future<void> blockUser() async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      final body = {
        'block_to': user.value.id,
      };
      ResponseModel res = await net.post(UrlConst.blockUser, body);
      if (res.isSuccess) {
        onUpdate(status: Status.SCUSSESS);
        Get.back();
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e, () {
        blockUser();
      });
    }
  }

  Future<void> reportUser({
    required String reason,
  }) async {
    try {
      onUpdate(status: Status.LOADING_MORE);
      final body = {
        'to_user': user.value.id,
        'reason': reason,
      };
      ResponseModel res = await net.post(UrlConst.reportuser, body);
      if (res.isSuccess) {
        Get.back();
        showSnackBar('User Reported');
        onUpdate(status: Status.SCUSSESS);
      } else {
        throw res.message;
      }
    } catch (e) {
      onError(e, () {
        reportUser(reason: reason);
      });
    }
  }
}
