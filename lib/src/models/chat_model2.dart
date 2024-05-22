import 'dart:convert';

import '../../src_exports.dart';

/// firebase chat model
class ChatModel {
  factory ChatModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return ChatModel(
        unreadCount: app.showBusinessChat.value
            ? doc['${app.bussiness.id}']
            : doc['${app.user.id}'] ?? 0,
        chatID: doc['chatID'] ?? '',
        users: List<String>.from(doc['users'] ?? <String>[]),
        created_at: doc['created_at'] == null
            ? DateTime.now()
            : (doc['created_at'] as Timestamp).toDate(),
        last_message: doc['last_message'] ?? '',
        message_type: doc['message_type'] ?? 1,
        sender_id: doc['sender_id'] ?? '',
        isChatLiked: doc['isChatLiked'] ?? false,
        updated_at: doc['updated_at'] == null
            ? DateTime.now()
            : (doc['updated_at'] as Timestamp).toDate(),
      );
    } catch (e) {
      logger.e(e);
      return ChatModel();
    }
  }

  factory ChatModel.fromJson(Map<String, dynamic> json, bool showBusinessChat) {
    return ChatModel(
      unreadCount: showBusinessChat
          ? json['${app.bussiness.id}'] ?? 0
          : json['${app.user.id}'] ?? 0,
      chatID: json['chatID'] ?? '',
      users: List<String>.from(json['users'] ?? <String>[]),
      created_at: json['created_at'] == null
          ? DateTime.now()
          : (json['created_at'] as Timestamp).toDate(),
      last_message: json['last_message'] ?? '',
      message_type: json['message_type'] ?? 1,
      sender_id: json['sender_id'] ?? '',
      isChatLiked: json['isChatLiked'] ?? false,
      updated_at: json['updated_at'] == null
          ? DateTime.now()
          : (json['updated_at'] as Timestamp).toDate(),
    );
  }

  ChatModel({
    this.chatID = '',
    this.users = const <String>[],
    this.created_at,
    this.chatUser,
    this.unreadCount = 0,
    this.last_message = '',
    this.message_type = 1,
    this.sender_id = '',
    this.updated_at,
    this.isChatLiked = false,
  });

  String chatID;
  List<String> users;
  DateTime? created_at;
  String last_message;
  int message_type;
  String sender_id;
  DateTime? updated_at;
  UserModel? chatUser;
  bool isChatLiked;
  int unreadCount;
  UserModel _user = UserModel();

  RxBool is_like = false.obs;

  String get displayUnreadCount {
    if (unreadCount > 9) {
      return '9+';
    } else {
      return unreadCount.toString();
    }
  }

  List<Map<String, dynamic>> get chatUsers =>
      List<Map<String, dynamic>>.from(users.map((String e) => jsonDecode(e)));

  set user(UserModel user) {
    _user = user;
  }

  UserModel get user {
    if (_user.id == 0) {
      Map<String, dynamic> data =
          chatUsers.firstWhere((Map<String, dynamic> element) {
        return element['id'] != app.user.id.toString();
      }, orElse: () {
        return {};
      });
      UserModel user = UserModel(id: int.parse(data['id']));
      user.isBusiness = data['isBusiness'];
      return user;
    } else {
      return _user;
    }
  }

  RxBool is_reply = false.obs;

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatID,
      'users': users,
      'created_at': created_at ?? DateTime.now(),
      'last_message': last_message,
      'message_type': message_type,
      'sender_id': sender_id,
      'isChatLiked': isChatLiked,
      'updated_at': updated_at ?? DateTime.now(),
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'chatID': chatID,
      'users': users,
      'message_type': message_type,
      'sender_id': sender_id,
    };
  }
}

class MessageModel {
  factory MessageModel.fromDoc(DocumentSnapshot doc) {
    return MessageModel(
      created_at: (doc['created_at'] as Timestamp).toDate(),
      message_type: doc['message_type'] ?? 1,
      sender_id: doc['sender_id'] ?? '',
      status: doc['status'] ?? 1,
      message: doc['message'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
    );
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      created_at: (json['created_at'] as Timestamp).toDate(),
      message_type: json['message_type'] ?? 1,
      sender_id: json['sender_id'] ?? '',
      status: json['status'] ?? 1,
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      reply: ReplyModel.fromJson(json['reply'] ?? {}),
    );
  }

  MessageModel({
    this.id = '',
    this.created_at,
    this.message_type = 1,
    this.sender_id = '',
    this.status = 1,
    this.message = '',
    this.imageUrl = '',
    this.reply,
  });

  DateTime? created_at;
  int message_type;
  String sender_id;
  int status;
  String message;
  String imageUrl;
  String id;
  ReplyModel? reply;

  RxBool is_reply = false.obs;

  Map<String, dynamic> toJson() {
    return {
      'created_at': created_at ?? DateTime.now(),
      'message_type': message_type,
      'sender_id': sender_id,
      'status': status,
      'message': message,
      'imageUrl': imageUrl,
      if (reply != null) 'reply': reply!.toJson(),
    };
  }
}

class ReplyModel {
  ReplyModel({
    this.id = '',
    this.message = '',
    this.senderId = '',
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      senderId: json['senderId'] ?? '',
    );
  }

  String id;
  String message;
  String senderId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'senderId': senderId,
    };
  }
}
