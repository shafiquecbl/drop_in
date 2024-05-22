import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../src_exports.dart';

class LiveLocationModel {
  factory LiveLocationModel.fromJson(Map<String, dynamic> json) {
    LiveLocationModel foo = LiveLocationModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      userId: json['user_id'] ?? 0,
      image: json['image'] ?? '',
      lat: double.tryParse('${json['lat']}') ?? 0.0,
      long: double.tryParse('${json['long']}') ?? 0.0,
      isLive: json['is_live'] ?? false,
      userName: json['user_name'] ?? '',
      createdAt: FieldValue.serverTimestamp(),
    );
    return foo;
  }

  LiveLocationModel({
    required this.createdAt,
    this.id = '',
    this.userId = 0,
    this.description = '',
    this.image = '',
    this.lat = 0.0,
    this.long = 0.0,
    this.isLive = false,
    this.userName = '',
  });
  String id;
  int userId;
  String image;
  String description;
  double lat;
  double long;
  bool isLive;
  String userName;
  FieldValue createdAt;

  Marker marker = Marker(
    markerId: MarkerId(''),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'description': description,
        'user_id': userId,
        'image': image,
        'lat': lat,
        'long': long,
        'is_live': isLive,
        'user_name': userName,
        'timestamp': createdAt,
      };

  LatLng get toLatLng => LatLng(lat, long);
}
