import 'package:dropin/src/models/bussiness_model.dart';
import 'package:dropin/src/models/user_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

/// api chat model
class ChatDetailsModel {
  factory ChatDetailsModel.fromJson(Map<String, dynamic> json) =>
      ChatDetailsModel(
        id: json['id'] ?? 0,
        uOne: json['u_one'] ?? 0,
        uTwo: json['u_two'] ?? 0,
        type: json['type'] ?? 0,
        status: json['status'] ?? 0,
        liked: json['liked'] == 1,
        user: UserModel.fromJson(json['user'] ?? {}),
      );

  ChatDetailsModel({
    this.id = 0,
    this.uOne = 0,
    this.uTwo = 0,
    this.type = 0,
    this.status = 0,
    this.user,
    this.business,
    this.liked = false,
  }) {
    user ??= UserModel();
    business ??= BussinessModel();
  }

  int id;
  int uOne;
  int uTwo;
  int type;
  int status;
  UserModel? user;
  BussinessModel? business;
  bool liked;

  bool isBusiness = false;

  RxBool is_like = false.obs;
  RxBool is_reply = false.obs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'u_one': uOne,
        'u_two': uTwo,
        'type': type,
        'status': status,
        'user': user?.toJson(),
        'business': business?.toJson(),
      };
}
