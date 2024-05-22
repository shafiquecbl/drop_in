class GeneralModel {
  int onlineUsers;
  int activeAccountToday;

  GeneralModel({
    this.onlineUsers = 0,
    this.activeAccountToday = 0,
  });

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
        onlineUsers: json["online_users"] ?? 0,
        activeAccountToday: json["active_account_today"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "online_users": onlineUsers,
        "active_account_today": activeAccountToday,
      };
}
