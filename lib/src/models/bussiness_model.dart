// To parse this JSON data, do
//
//     final addBussinessModel = addBussinessModelFromJson(jsonString);

import 'dart:convert';

import 'package:dropin/src/models/sub_category_model.dart';

import '../../src_exports.dart';

BussinessModel addBussinessModelFromJson(String str) =>
    BussinessModel.fromJson(json.decode(str));

String addBussinessModelToJson(BussinessModel data) =>
    json.encode(data.toJson());

class BussinessModel {
  BussinessModel({
    this.id = 0,
    this.catId = 0,
    this.userId = 0,
    this.location = '',
    this.businessName = '',
    this.businessAddress = '',
    this.description = '',
    this.lat = 0.0,
    this.lang = 0.0,
    this.status = 0,
    this.catName = '',
    this.icon = '',
    this.coverPhoto = const <CoverPhoto>[],
    this.subCategory = const <SubCategory>[],
    this.businessRating = 0.0,
    this.ratedByCount = 0,
    this.first_name = '',
    this.last_name = '',
    this.email = '',
    this.visitToday = 0,
    this.totalVisit = 0,
  });

  factory BussinessModel.fromJson(Map<String, dynamic> json) {
    try {
      return BussinessModel(
        id: json['id'] ?? 0,
        catId: json['cat_id'] ?? 0,
        userId: json['user_id'] ?? 0,
        location: json['location'] ?? '',
        businessAddress: json['address'] ?? '',
        first_name: json['first_name'] ?? '',
        last_name: json['last_name'] ?? '',
        email: json['email'] ?? '',
        icon: json['icon'] ?? '',
        businessName: json['business_name'] ?? '',
        description: json['description'] ?? '',
        lat: double.tryParse('${json["lat"] ?? ''}') ?? 0.0,
        lang: double.tryParse('${json["lang"] ?? ''}') ?? 0.0,
        status: json['status'] ?? 0,
        visitToday: json['today_visits'] ?? 0,
        totalVisit: json['total_visits'] ?? 0,
        catName: json['cat_name'] ?? '',
        coverPhoto: List<CoverPhoto>.from(
          (json['cover_photo'] ?? []).map((x) => CoverPhoto.fromJson(x)),
        ),
        subCategory: List<SubCategory>.from(
          (json['sub_category'] ?? []).map((x) => SubCategory.fromJson(x)),
        ),
        businessRating: double.tryParse('${json["business_rating"]}') ?? 0.0,
        ratedByCount: json['rated_by_count'] ?? 0,
      );
    } catch (e, t) {
      logger.e('model', error: e, stackTrace: t);
      return BussinessModel();
    }
  }

  UserModel get getFakeUser {
    return UserModel(
      id: id,
      userName: businessName,
      email: email,
      firstName: first_name,
      lastName: last_name,
      profileImg: coverPhoto.isNotEmpty ? coverPhoto.first.coverPhoto : '',
    );
  }

  int id;
  int catId;
  int userId;
  String location;
  String businessName;
  String businessAddress;
  String description;
  double lat;
  double lang;
  String icon;
  String first_name;
  String last_name;
  String email;
  int status;
  int visitToday;
  int totalVisit;
  String catName;
  List<CoverPhoto> coverPhoto;
  List<SubCategory> subCategory;
  double businessRating;
  int ratedByCount;
  RxBool isSelected = false.obs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'cat_id': catId,
        'user_id': userId,
        'location': location,
        'business_name': businessName,
        'address': businessAddress,
        'description': description,
        'lat': lat,
        'lang': lang,
        'status': status,
        'today_visits': visitToday,
        'total_visits': totalVisit,
        'cat_name': catName,
        'icon': icon,
        'cover_photo':
            List<dynamic>.from(coverPhoto.map((CoverPhoto x) => x.toJson())),
        'sub_category':
            List<dynamic>.from(subCategory.map((SubCategory x) => x.toJson())),
        'business_rating': businessRating,
        'rated_by_count': ratedByCount,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
      };
}

class CoverPhoto {
  CoverPhoto({
    this.id = 0,
    this.businessId = 0,
    this.coverPhoto = '',
    this.status = 0,
  });

  factory CoverPhoto.fromJson(Map<String, dynamic> json) => CoverPhoto(
        id: json['id'] ?? 0,
        businessId: json['business_id'] ?? 0,
        coverPhoto: json['cover_photo'] ?? '',
        status: json['status'] ?? 0,
      );
  int id;
  int businessId;
  String coverPhoto;
  int status;

  String get photos {
    if (coverPhoto.isNotEmpty) {
      logger.w('${UrlConst.coverImg}$coverPhoto');
      return '${UrlConst.coverImg}$coverPhoto';
    } else {
      return UrlConst.noImage;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'business_id': businessId,
        'cover_photo': coverPhoto,
        'status': status,
      };
}
