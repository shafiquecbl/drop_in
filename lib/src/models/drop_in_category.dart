/// this is business model
class DropCategoryModel {
  factory DropCategoryModel.fromJson(Map<String, dynamic> json) =>
      DropCategoryModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        icon: json['icon'] ?? '',
        status: json['status'] ?? 0,
      );

  DropCategoryModel({
    this.id = 0,
    this.name = '',
    this.icon = '',
    this.status = 0,
  });
  int id;
  String name;
  String icon;
  int status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'status': status,
      };
}
