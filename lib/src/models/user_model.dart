import 'package:dropin/src/models/extensions.dart';
import 'package:dropin/src/models/news_feed_model.dart';
import 'package:dropin/src_exports.dart';

import 'dart:convert';

import 'bussiness_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  int role;
  String fId;
  String firstName;
  String lastName;
  String email;
  String password;
  String bio;
  String profileImg;
  List<CoverPhoto> coverPhotos;
  List<NewsFeedModel> dropIns;
  BussinessModel? bussiness;

  String userName;
  String country;
  DateTime? dob;
  int skillId;
  int isLocation;
  int isActive;
  double lat;
  double lang;
  int status;
  int like_count;
  String apikey;
  String token;
  DateTime? created_at;
  bool is_like;
  RxBool isSelected = false.obs;
  int report_count;
  bool isBusiness = false;

  UserModel({
    this.id = 0,
    this.fId = '',
    this.role = 0,
    this.coverPhotos = const [],
    this.dropIns = const [],
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.bio = '',
    this.profileImg = '',
    this.userName = '',
    this.country = '',
    this.dob,
    this.skillId = 0,
    this.lat = 0.0,
    this.lang = 0.0,
    this.status = 0,
    this.is_like = false,
    this.report_count = 0,
    this.apikey = '',
    this.token = '',
    this.isActive = 0,
    this.isLocation = 0,
    this.created_at,
    this.like_count = 0,
    this.bussiness,
  }) {
    dob ??= DateTime.now();
    created_at ??= DateTime.now();
  }

  bool get hasUser => id != 0;

  bool isChatLiked = false;

  String get fullName => '$firstName $lastName';

  String get imageUrl {
    if (profileImg.isNotEmpty) {
      return UrlConst.profileBase + profileImg;
    } else {
      return UrlConst.noImage;
    }
  }

  int get age {
    final foo = DateTime.now().difference(dob!).inDays ~/ 365;
    logger.w(foo);
    logger.w(dob);
    return foo;
  }

  String get skillLevel {
    switch (skillId) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advance';
      default:
        return '';
    }
  }

  String get img {
    if (isBusiness) {
      return '${UrlConst.coverImg}$profileImg';
    } else {
      return '${UrlConst.profileBase}$profileImg';
    }
  }

  String get businessImage {
    if (profileImg.isNotEmpty) {
      return '${UrlConst.coverImg}$profileImg';
    } else {
      return UrlConst.noImage;
    }
  }

  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
        id: json[KeyConst.id] ?? 0,
        report_count: json['report_count'] ?? 0,
        like_count: json[KeyConst.like_count] ?? 0,
        is_like: json[KeyConst.isLink] == 1,
        fId: json[KeyConst.fId] ?? '',
        apikey: json[KeyConst.apiKey] ?? '',
        token: json[KeyConst.token] ?? '',
        userName: json[KeyConst.uName] ?? '',
        lastName: json[KeyConst.lastName] ?? '',
        firstName: json[KeyConst.firstname] ?? '',

        email: json[KeyConst.email] ?? '',
        password: json[KeyConst.password] ?? '',
        coverPhotos: json[KeyConst.cover_photos] == null
            ? []
            : List<CoverPhoto>.from(
                json[KeyConst.cover_photos].map(
                  (e) {
                    var res = CoverPhoto.fromJson(e);
                    return res;
                  },
                ),
              ),
        dropIns: List<NewsFeedModel>.from(
          (json['dropins'] ?? []).map(
            (e) => NewsFeedModel.fromJson(e),
          ),
        ),
        dob: DateTime.tryParse(json[KeyConst.dob] ?? '') ?? DateTime(0),
        country: json[KeyConst.country] ?? '',
        profileImg: json[KeyConst.profileImg] ?? '',
        lang: double.tryParse((json[KeyConst.lang] ?? '').toString()) ?? 0.0,
        lat: double.tryParse((json[KeyConst.lat] ?? '').toString()) ?? 0.0,
        bio: json[KeyConst.bio] ?? '',
        role: json[KeyConst.role] ?? 0,
        isLocation: json['is_location'] ?? 0,
        isActive: json['is_active'] ?? 0,
        skillId: json[KeyConst.skill_id] ?? 0,
        status: json[KeyConst.status] ?? 0,
        bussiness: BussinessModel.fromJson(json[KeyConst.businessDetails] ?? {}),
        // created_at: (json['created_at'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        KeyConst.fId: fId,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'bio': bio,
        'profile_img': profileImg,
        'user_name': userName,
        'country': country,
        'dob': dob!.sendToDb,
        'skill_id': skillId,
        'lat': lat,
        'lang': lang,
        'like_count': like_count,
        'is_liked': is_like,
        'report_count': report_count,
        'cover_photo': List<dynamic>.from(
          coverPhotos.map(
            (x) => x.toJson(),
          ),
        ),
        'status': status,
        'apikey': apikey,
        'token': token,
    KeyConst.businessDetails: bussiness?.toJson() ?? {},
        'dropins': dropIns,
      };
}

class CoverPhoto {
  int id;
  int userId;
  String coverPhoto;
  int status;

  CoverPhoto({
    this.id = 0,
    this.userId = 0,
    this.coverPhoto = '',
    this.status = 0,
  });

  String get url {
    if (coverPhoto.isNotEmpty && !isFileImage) {
      return '${UrlConst.coverImg}$coverPhoto';
    } else {
      return UrlConst.noImage;
    }
  }

  bool get isFileImage {
    return coverPhoto.toLowerCase().contains('data');
  }

  factory CoverPhoto.fromJson(Map<String, dynamic> json) => CoverPhoto(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        coverPhoto: json['cover_photo'] ?? '',
        status: json['status'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'cover_photo': coverPhoto,
        'status': status,
      };
}
