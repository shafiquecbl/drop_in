import 'package:dropin/src/service/NotificationService.dart';
import '../../../src_exports.dart';
import '../../models/chat_details_model.dart';
import '../../models/chat_model2.dart';
import '../../models/news_feed_model.dart';
import '../../service/network_service.dart';
import '../chatscreen/chat_screen_controller.dart';

class InBoxScreenController extends ChatScreenController {
  ChatDetailsModel? chatModel;

  @override
  Future<void> chatLike({required ChatModel chat}) {
    ChatModel foo = chat;
    foo.isChatLiked = !chat.isChatLiked;
    chatMode = foo;
    onUpdate();
    return super.chatLike(chat: chat);
  }

  TextEditingController messageCTRL = TextEditingController();
  RxList<String> token = <String>[].obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<MessageModel> messageList = <MessageModel>[];
  String? message;
  NewsFeedModel? userId;
  FilePickerResult? result;
  PlatformFile? pickedFile;
  RxString imageUrl = ''.obs;
  String url = '';
  ChatModel chatMode = Get.arguments;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // RxBool rightSelected = false.obs;
  // RxBool leftSelected = false.obs;

  RxList<ChatModel> chats = <ChatModel>[].obs;

  Future<void> sendMessage({
    required MessageModel messageModel,
    required String chatId,
    required int id,
    required bool isBusiness,
  }) async {
    if (messageModel.message.trim().isNotEmpty) {
      MessageModel chatModel = MessageModel(
        message_type: 1,
        message: messageModel.message,
      );
      _db.collection('chat').doc(chatId).update({
        'created_at': FieldValue.serverTimestamp(),
        'last_message': messageCTRL.text.trim(),
        '$id': FieldValue.increment(1),
        '${messageModel.sender_id}': 0,
      });
      _db.collection('chat').doc(chatId).collection('messages').add(
            messageModel.toJson(),
          );
      Map<String, dynamic> body = {
        if (isBusiness) ...{
          'bussiness_id': id,
        } else ...{
          'u_id': id
        },
      };
      ResponseModel res = await net.get(
        UrlConst.getFCM,
        body,
      );
      logger.w(res.data.map((e) => e['fcmToken']).toList());
      List<String> token =
          List<String>.from(res.data.map((e) => e['fcmToken']));
      logger.w(token);
      token.forEach((String element) {
        notifyToUser(
          message: messageCTRL.text,
          title: app.user.userName,
          contactPushToken: element,

        );
      });
    }
  }

  Future<void> notifyToUser(
      {required String message,
      required String title,
      dynamic contactPushToken}) async {
    logger.w('Message::$message');
    await NotificationService().sendAndRetrieveMessage(
      type: 1,
      message: message,
      title: title,
      contactPushToken: contactPushToken,
    );
  }
}
