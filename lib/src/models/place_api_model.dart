class PlaceApiModel {
  Result? result;
  String status;

  PlaceApiModel({
    this.result,
    this.status = '',
  }) {
    result ??= Result();
  }

  factory PlaceApiModel.fromJson(Map<String, dynamic> json) => PlaceApiModel(
        result: Result.fromJson(json['result'] ?? {}),
        status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'result': result?.toJson(),
        'status': status,
      };
}

class Result {
  Geometry? geometry;

  Result({
    this.geometry,
  }) {
    geometry ??= Geometry();
  }

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        geometry: Geometry.fromJson(json['geometry']),
      );

  Map<String, dynamic> toJson() => {
        'geometry': geometry!.toJson(),
      };
}

class Geometry {
  Location? location;

  Geometry({
    this.location,
  }) {
    location ??= Location();
  }

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json['location']),
      );

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
      };
}

class Location {
  double lat;
  double lng;

  Location({
    this.lat = 0.0,
    this.lng = 0.0,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json['lat'].toDouble(),
        lng: json['lng'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
