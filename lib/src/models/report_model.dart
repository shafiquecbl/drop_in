import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ReportModel {
  ReportModel({
    this.id = 0,
    this.dropinId = 0,
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.name = '',
    this.reportCount = 0,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] ?? 0,
        dropinId: json['dropin_id'] ?? 0,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        reportCount: json['report_count'] ?? 0,
      );

  int id;
  int dropinId;
  String firstName;
  String lastName;
  String email;
  String name;
  int reportCount;

  RxBool isSelected = false.obs;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'name': name,
        'dropin_id': dropinId,
        'report_count': reportCount,
      };
}
