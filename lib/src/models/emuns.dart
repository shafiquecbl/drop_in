import 'package:dropin/src/utils/const/asset_const.dart';

enum Status { IDEL, LOADING, SCUSSESS, FAILED, LOADING_MORE, SEARCHING }

enum BusinessCategoryType {
  Photographer(
    'Photographer',
    AppAssets.photographypin,
    ['Photography', 'Videography'],
    AppAssets.photographypin,
    AppAssets.photographypinOwn,
    1,
  ),
  Surf_Shop(
    'Surf Shop',
    AppAssets.surfShopMarker,
    ['Rentals', 'Surf Equipment', 'Apparel'],
    AppAssets.surfShopMarker,
    AppAssets.AccomodationpinOwn,
    2,
  ),
  Surf_Accommodation(
    'Surf Accommodation',
    AppAssets.accomodation,
    ['Dorm Rooms', 'Private Rooms', 'Private Bathrooms', 'Private Kitchens'],
    AppAssets.accomodation,
    AppAssets.accomodationOwn,
    3,
  ),
  Surf_Camp(
    'Surf Camp',
    AppAssets.camp,
    ['Semi-Inclusive', 'All-Inclusive', 'Dorm Rooms', 'Private Rooms'],
    AppAssets.camp,
    AppAssets.campOwn,
    4,
  ),
  Surf_School(
    'Surf School',
    AppAssets.School,
    ['Private Lessons', 'Group Lessons', 'Rentals'],
    AppAssets.School,
    AppAssets.SchoolOwn,
    5,
  );


  const BusinessCategoryType(
    this.title,
    this.icon,
    this.subCategory,
    this.markerPath,
    this.ownMarkerPath,
    this.id,
  );

  final int id;
  final String title;
  final String icon;
  final List<String> subCategory;
  final String markerPath;
  final String ownMarkerPath;

  static BusinessCategoryType businessCategoryType(int id) {
    return BusinessCategoryType.values
        .firstWhere((BusinessCategoryType element) => element.id == id);
  }
}

enum DropInCategory {
  GoingToSurfing('Going Surfing', AppAssets.surfing, 1),
  SurfTripRideShare('Surf Trip RideShare', AppAssets.rideshare, 2),
  MeetOthers('Meet Others', AppAssets.meetother, 3),
  WantingPhotographer('Wanting Photographer', AppAssets.photographerwanted, 4),
  BuyAndShare('Buy and Sell', AppAssets.Sell, 5);

  const DropInCategory(this.title, this.iconPath, this.id);

  final String title;
  final String iconPath;
  final int id;
}

enum SkillLevel {
  Beginner(1, 'Beginner'),
  InterMediate(2, 'Intermediate'),
  Advance(3, 'Advance');

  const SkillLevel(this.id, this.title);

  final int id;
  final String title;
}
