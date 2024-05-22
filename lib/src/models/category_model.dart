import 'package:dropin/src/models/sub_category_model.dart';

class CategoryModel {
  CategoryModel({
    this.id = 0,
    this.name = '',
    this.icon = '',
    this.status = 0,
    this.subCategory = const <SubCategory>[],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        icon: json['icon'] ?? '',
        status: json['status'] ?? 0,
        subCategory: List<SubCategory>.from(
          (json['sub_category'] ?? []).map(
            (e) => SubCategory.fromJson(e),
          ),
        ),
      );

  int id;
  String name;
  String icon;
  int status;
  List<SubCategory> subCategory;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'status': status,
        'sub_category': subCategory,
      };
}
