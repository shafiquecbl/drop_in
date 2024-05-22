import 'dart:convert';

import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

import '../../src_exports.dart';

MapModel mapModelFromJson(String str) => MapModel.fromJson(json.decode(str));

String mapModelToJson(MapModel data) => json.encode(data.toJson());

class MapModel {
  List<BusinessDetail> businessDetails;
  List<BusinessDetail> userDropin;

  MapModel({
    this.businessDetails = const [],
    this.userDropin = const [],
  });

  factory MapModel.fromJson(Map<String, dynamic> json) => MapModel(
        businessDetails: List<BusinessDetail>.from(
          (json['business_details'] ?? []).map((x) {
            x.addAll({'isBusiness': true});
            return BusinessDetail.fromJson(x);
          }),
        ),
        userDropin: List<BusinessDetail>.from(
          (json['user_dropin'] ?? []).map(
            (x) => BusinessDetail.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        'businessDetails': businessDetails,
        'userDropin': userDropin,
      };
}

class BusinessDetail {
  int id;
  int type;
  int userId;
  String loc;
  String businessName;
  String description;
  double lat;
  double lang;
  double distanceInKm;
  String title;
  bool isBusiness;
  List<DropInImage> dropinImages;
  List<DropInImage> coverImages;

  BusinessDetail({
    this.id = 0,
    this.type = 0,
    this.userId = 0,
    this.loc = '',
    this.businessName = '',
    this.description = '',
    this.lat = 0.0,
    this.lang = 0.0,
    this.distanceInKm = 0.0,
    this.title = '',
    this.isBusiness = false,
    this.dropinImages = const [],
    this.coverImages = const [],
  });

  factory BusinessDetail.fromJson(Map<String, dynamic> json) => BusinessDetail(
        id: json['id'] ?? 0,
        type: json['type'] ?? json['TYPE'] ?? 0,
        userId: json['user_id'] ?? 0,
        loc: json['location'] ?? '',
        businessName: json['business_name'] ?? '',
        description: json['description'] ?? '',
        lang: double.tryParse((json['lang'] ?? '').toString()) ?? 0.0,
        lat: double.tryParse((json['lat'] ?? '').toString()) ?? 0.0,
        distanceInKm:
            double.tryParse((json['distance_in_km'] ?? '').toString()) ?? 0.0,
        title: json['title'] ?? '',
        isBusiness: json['isBusiness'] ?? false,
        dropinImages: List<DropInImage>.from(
            (json['dropin_images'] ?? []).map((e) => DropInImage.fromJson(e))),
        coverImages: List<DropInImage>.from(
            (json['cover_photo'] ?? []).map((e) => DropInImage.fromJson(e))),
      );

  String get iconPath {
    if (isBusiness) {
      BusinessCategoryType t = BusinessCategoryType.businessCategoryType(type);
      if(userId == app.user.id && type == (app.user.bussiness?.catId ?? 0)){
          return t.ownMarkerPath;
      }else{
        return t.markerPath;
      }
    } else {
      DropInCategory t = DropInCategory.values[type - 1];
      return t.iconPath;
    }
  }

  LatLng toLatLong() => LatLng(lat, lang);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'user_id': userId,
        'location': loc,
        'business_name': businessName,
        'description': description,
        'lat': lat,
        'lang': lang,
        'distance_in_km': distanceInKm,
        'title': title,
        'isBusiness': isBusiness,
      };
}

class DropInImage {
  int id;
  int dropinId;
  String image;

  DropInImage({this.id = 0, this.dropinId = 0, this.image = ''});

  factory DropInImage.fromJson(Map<String, dynamic> json) {
    return DropInImage(
      id: json['id'] ?? 0,
      dropinId: json['d_id'] ?? json['business_id'] ?? 0,
      image: json['images'] ?? json['cover_photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'd_id': dropinId,
      'images': image,
    };
  }
}
