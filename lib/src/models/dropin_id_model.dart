// To parse this JSON data, do
//
//     final dropinById = dropinByIdFromJson(jsonString);

import 'dart:convert';

import 'package:dropin/src/models/user_model.dart';

DropinById dropinByIdFromJson(String str) =>
    DropinById.fromJson(json.decode(str));

String dropinByIdToJson(DropinById data) => json.encode(data.toJson());

class DropinById {
  factory DropinById.fromJson(Map<String, dynamic> json) => DropinById(
        id: json['id'],
        userId: json['user_id'],
        catId: json['cat_id'],
        location: json['location'],
        title: json['title'],
        description: json['description'],
        image: json['image'],
        lat: json['lat'].toDouble(),
        lang: json['lang'].toDouble(),
        status: json['status'],
        user: UserModel.fromJson(json['user']),
      );

  DropinById({
    this.id = 0,
    this.userId = 0,
    this.catId = 0,
    this.location = '',
    this.title = '',
    this.description = '',
    this.image = '',
    this.lat = 0.0,
    this.lang = 0.0,
    this.status = 0,
    this.user,
  });
  int id;
  int userId;
  int catId;
  String location;
  String title;
  String description;
  String image;
  double lat;
  double lang;

  int status;
  UserModel? user;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'cat_id': catId,
        'location': location,
        'title': title,
        'description': description,
        'image': image,
        'lat': lat,
        'lang': lang,
        'status': status,
        'user': user?.toJson(),
      };
}
