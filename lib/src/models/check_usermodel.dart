class CheckUser {
  factory CheckUser.fromJson(Map<String, dynamic> json) => CheckUser(
        id: json['id'] ?? 0,
        fId: json['f_id'] ?? '',
        email: json['email'] ?? '',
        userName: json['user_name'] ?? '',
      );

  CheckUser({
    this.id = 0,
    this.fId = '',
    this.email = '',
    this.userName = '',
  });

  int id;
  String fId;
  String email;
  String userName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'f_id': fId,
        'email': email,
        'user_name': userName,
      };
}
