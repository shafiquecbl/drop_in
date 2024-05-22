import '../../src_exports.dart';

class DropInModel {
  int id;
  int userId;
  int catId;
  String location;
  String title;
  String description;
  dynamic image;
  double lat;
  double lang;
  int status;

  DropInModel({
    this.id = 0,
    this.catId = 0,
    this.description = '',
    this.image,
    this.location = '',
    this.lang = 0.0,
    this.lat = 0.0,
    this.status = 0,
    this.title = '',
    this.userId = 0,
  });

  factory DropInModel.fromJson(Map<String, dynamic> json) => DropInModel(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        catId: json['cat_id'] ?? 0,
        location: json['location'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        lang: double.tryParse((json[KeyConst.lang] ?? '').toString()) ?? 0.0,
        lat: double.tryParse((json[KeyConst.lat] ?? '').toString()) ?? 0.0,
        status: json['status'],
      );

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
      };
}
