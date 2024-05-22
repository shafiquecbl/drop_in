// To parse this JSON data, do
//
//     final subCategory = subCategoryFromJson(jsonString);

import 'dart:convert';

List<SubCategory> subCategoryFromJson(String str) => List<SubCategory>.from(
    json.decode(str).map((x) => SubCategory.fromJson(x)));

String subCategoryToJson(List<SubCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategory {
  int id;
  int catId;
  String name;
  String icon;
  int status;

  SubCategory({
    this.id = 0,
    this.catId = 0,
    this.icon = '',
    this.name = '',
    this.status = 0,
  });


  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json['id'] ?? 0,
        catId: json['cat_id'] ?? json['sub_cat_id'] ?? '',
        name: json['name'] ?? json['subcategory'] ?? '',
        icon: json['icon'] ?? '',
        status: json['status'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cat_id': catId,
        'name': name,
        'icon': icon,
        'status': status,
      };
}
