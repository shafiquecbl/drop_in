class StatModel {
  int totalUsers;
  int activeUsers;
  int newUsers;
  int newUsersSevendays;
  int totalDropins;
  int goingSurfing;
  int meetOthers;
  int wantingPhotographer;
  int surfTripRideshare;
  int buyAndSell;
  int totalBusiness;
  int totalBusinessRated;
  String totalVisits;
  double totalAverageRatingBusiness;
  int photographer;
  int surfShop;
  int surfAccomodation;
  int surfCamp;
  int surfSchool;
  int totalChats;
  int activateLocation;
  int lastChatSevendays;

  StatModel({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.newUsers = 0,
    this.newUsersSevendays = 0,
    this.totalDropins = 0,
    this.goingSurfing = 0,
    this.meetOthers = 0,
    this.wantingPhotographer = 0,
    this.surfTripRideshare = 0,
    this.buyAndSell = 0,
    this.totalBusiness = 0,
    this.totalBusinessRated = 0,
    this.totalAverageRatingBusiness = 0.0,
    this.photographer = 0,
    this.surfShop = 0,
    this.surfAccomodation = 0,
    this.surfCamp = 0,
    this.surfSchool = 0,
    this.totalChats = 0,
    this.totalVisits = '0.0',
    this.activateLocation = 0,
    this.lastChatSevendays = 0,
  });

  factory StatModel.fromJson(Map<String, dynamic> json) => StatModel(
        totalUsers: json['total_users'] ?? 0,
        activeUsers: json['active_users'] ?? 0,
        newUsers: json['new_users'] ?? 0,
        newUsersSevendays: json['new_users_sevendays'] ?? 0,
        totalDropins: json['total_dropins'] ?? 0,
        goingSurfing: json['going_surfing'] ?? 0,
        meetOthers: json['meet_others'] ?? 0,
        wantingPhotographer: json['wanting_photographer'] ?? 0,
        surfTripRideshare: json['surf_trip_rideshare'] ?? 0,
        buyAndSell: json["buy_and_sell"] ?? 0,
        totalBusiness: json["total_business"] ?? 0,
        totalVisits: json["total_visits"] ?? '',
        totalBusinessRated: json["total_business_rated"] ?? 0,
        totalAverageRatingBusiness: double.tryParse(
                (json['total_average_rating_business'] ?? '').toString()) ??
            0.0,
        photographer: json["photographer"] ?? 0,
        surfShop: json["surf_shop"] ?? 0,
        surfAccomodation: json["surf_accomodation"] ?? 0,
        surfCamp: json["surf_camp"] ?? 0,
        surfSchool: json["surf_school"] ?? 0,
        totalChats: json["total_chats"] ?? 0,
        activateLocation: json["activate_location"] ?? 0,
        lastChatSevendays: json["last_chat_sevendays"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "total_users": totalUsers,
        "active_users": activeUsers,
        "new_users": newUsers,
        "new_users_sevendays": newUsersSevendays,
        "total_dropins": totalDropins,
        "going_surfing": goingSurfing,
        "meet_others": meetOthers,
        "wanting_photographer": wantingPhotographer,
        "surf_trip_rideshare": surfTripRideshare,
        "buy_and_sell": buyAndSell,
        "total_business": totalBusiness,
        "total_business_rated": totalBusinessRated,
        "total_average_rating_business": totalAverageRatingBusiness,
        "photographer": photographer,
        "surf_shop": surfShop,
        "surf_accomodation": surfAccomodation,
        "surf_camp": surfCamp,
        "surf_school": surfSchool,
        "total_chats": totalChats,
        "activate_location": activateLocation,
        "last_chat_sevendays": lastChatSevendays,
        "total_visits": totalVisits,
      };
}
