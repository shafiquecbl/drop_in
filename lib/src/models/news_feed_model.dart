import '../../src_exports.dart';

class NewsFeedModel {
  factory NewsFeedModel.fromJson(Map<String, dynamic> json) {
    try {
      return NewsFeedModel(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        catId: json['cat_id'] ?? 0,
        location: json['location'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        lat: double.tryParse('$json["lat"]') ?? 0.0,
        lang: double.tryParse('$json["lang"]') ?? 0.0,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'].toString())
            : DateTime(0),
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'].toString())
            : DateTime(0),
        distanceInKm: double.tryParse('$json["distance_in_km"]') ?? 0.0,
        icon: json['icon'] ?? '',
        user: UserModel.fromJson(json['user'] ?? {}),
        dropinImages: List<DropinImages>.from(
          (json['dropin_images'] ?? []).map(
            (x) => DropinImages.fromJson(x),
          ),
        ),
      );
    } catch (e) {
      return NewsFeedModel();
    }
  }

  NewsFeedModel({
    this.id = 0,
    this.userId = 0,
    this.catId = 0,
    this.icon = '',
    this.location = '',
    this.title = '',
    this.description = '',
    this.lat = 0.0,
    this.lang = 0.0,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.dropinImages = const <DropinImages>[],
    this.distanceInKm = 0.0,
  }) {
    user ??= UserModel();
  }

  String icon;
  int id;
  int userId;
  int catId;
  String location;
  String title;
  String description;

  double lat;
  double lang;
  DateTime? createdAt;
  DateTime? updatedAt;
  double distanceInKm;
  UserModel? user;
  List<DropinImages> dropinImages;

  RxBool showReport = false.obs;
  RxBool showDelete = false.obs;

  String get iconUrl {
    logger.w(icon);
    return UrlConst.otherMediaBase + icon;
  }

  String get image {
    if (dropinImages.isNotEmpty) {
      return dropinImages.first.images;
    } else {
      return '';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'icon': icon,
        'cat_id': catId,
        'location': location,
        'title': title,
        'description': description,
        // 'dropin_images': image,
        'lat': lat,
        'lang': lang,
        'distanceInKm': distanceInKm,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'user': user?.toJson(),
        'dropin_images': dropinImages.map((e) => e.toJson()),
      };
}

class DropinImages {
  factory DropinImages.fromJson(Map<String, dynamic> json) => DropinImages(
        id: json['id'] ?? 0,
        dId: json['d_id'] ?? 0,
        images: json['images'] ?? '',
        status: json['status'] ?? 0,
      );

  DropinImages({
    this.id = 0,
    this.dId = 0,
    this.images = '',
    this.status = 0,
  });

  int id;
  int dId;
  String images;

  int status;

  String get url {
    if (images.isNotEmpty) {
      logger.w('${UrlConst.dropinBaseUrl}$images');
      return '${UrlConst.dropinBaseUrl}$images';
    } else {
      return UrlConst.noImage;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'd_id': dId,
        'images': images,
        'status': status,
      };
}
