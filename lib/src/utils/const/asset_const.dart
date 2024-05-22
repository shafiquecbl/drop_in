import 'package:dropin/src_exports.dart';

class AppAssets {
  static Widget asFile(
    File image, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
    Clip clip = Clip.antiAlias,
    BorderRadiusGeometry? borderRadius,
  }) {
    return ClipRRect(
      clipBehavior: clip,
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        image,
        color: color,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }

  static Widget asImage(
    String image, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return Image.asset(
      image,
      color: color,
      height: height,
      width: width,
      fit: fit,
    );
  }

  static ImageProvider asProvider(String image) {
    return AssetImage(image);
  }

  // static LottieBuilder asAnimation({
  //   required String path,
  //   double? width,
  //   double? height,
  //   BoxFit? fit,
  // }) {
  //   return Lottie.asset(
  //     path,
  //     width: width,
  //     height: height,
  //     fit: fit,
  //     repeat: false,
  //   );
  // }

  static Widget asIcon(String icon, {Color? color, double? size}) {
    return ImageIcon(
      AssetImage(
        icon,
      ),
      color: color,
      size: size,
    );
  }

  static const String _authBase = 'assets/images/auth/';
  static const String _imageBase = 'assets/images/';
  static const String _iconBase = 'assets/icons/';
  static const String countryIcon = 'assets/country_icons/';
  static const String _styleBase = 'assets/styles/';
  static const String _webicons = 'assets/images/web/';

  static const String gMapsDefaultStyle = '${_styleBase}g_maps.txt';

  static const String noImage = '${_imageBase}no_image.jpg';

  static const String assetName = 'assetLocationString';
  static const String user = 'assets/icons/user.png';
  static const String login = '${_authBase}login.png';
  static const String backgroundImage = '${_authBase}appimage.png';
  static const String backgroundGif = 'assets/images/auth/backgroundgif.gif';
  static const String loginGif = '${_authBase}logingif.gif';
  static const String splash = '${_authBase}splash.png';
  static const String lock = '${_authBase}assets/lock.png';
  static const String arrowBack = '${_iconBase}arrow_back.png';
  static const String surfShopMarker = '${_imageBase}surfshop-pin.png';
  static const String surfWhite = '${_iconBase}surfWhite.png';
  static const String check = '${_iconBase}check.png';
  static const String like = '${_iconBase}like.png';
  static const String dislike = '${_iconBase}dislike.png';

  //icons
  static const String person = '${_authBase}Photo.png';
  static const String Report = '${_authBase}report.png';
  static const String carImage = '${_authBase}carImage.png';

  //icons
  static const String gallary = '${_iconBase}gallary.png';
  static const String signOut = '${_iconBase}SignOut.png';

  static const String camera = '${_iconBase}camera.png';
  static const String cap = '${_iconBase}cap.png';
  static const String search = '${_iconBase}search.png';
  static const String close = '${_iconBase}close.png';
  static const String dropIn = '${_iconBase}dropping.png';

  static const String photographypin = '${_iconBase}Photographer Pin.png';

  static const String accomodation = '${_iconBase}Accomodation.png';
  static const String accomodationOwn = '${_iconBase}Accomodation1.png';
  static const String Accomodationpin = '${_iconBase}Accomodation Pin.png';
  static const String plane = '${_iconBase}plane.png';
  static const String AccomodationpinOwn = '${_iconBase}Accomodation Pin1.png';
  static const String camp = '${_iconBase}Camp Pin.png';
  static const String campOwn = '${_iconBase}Camp Pin1.png';
  static const String photographer = '${_iconBase}Photographer Pin.png';
  static const String photographypinOwn = '${_iconBase}Photographer Pin1.png';
  static const String School = '${_iconBase}School Pin.png';
  static const String SchoolOwn = '${_iconBase}School Pin1.png';

  static const String meetother = '${_iconBase}Meet Others.png';
  static const String photographerwanted =
      '${_iconBase}Photographer Wanted.png';
  static const String surfing = '${_iconBase}Going Surfing.png';
  static const String cluster = '${_iconBase}cluster.png';
  static const String businessCluster = '${_iconBase}business_cluster.png';
  static const String rideshare = '${_iconBase}Rideshare.png';
  static const String Sell = '${_iconBase}Sell.png';

  static const String dolor = '${_iconBase}dolor.png';
  static const String dropinBed = '${_iconBase}dropin_bed.png';
  static const String dropinPin = '${_iconBase}dropin_pin.png';
  static const String shop = '${_iconBase}Shop.png';
  static const String currentLocation = '${_iconBase}current_location.png';
  static const String sleeping = '${_iconBase}sleeping.png';
  static const String tent = '${_iconBase}tent.png';
  static const String north = '${_iconBase}north.png';
  static const String home = '${_iconBase}home.png';
  static const String map = '${_iconBase}map.png';
  static const String dropin = '${_iconBase}dropIn.png';
  static const String dropinSelected = '${_iconBase}dropinSelected.png';
  static const String message = '${_iconBase}message.png';
  static const String profile = '${_iconBase}person.png';
  static const String shell = '${_iconBase}Sell.png';
  static const String flagicon = '${_iconBase}flagicon.png';
  static const String person1 = '${_iconBase}person1.png';
  static const String surfBoard = '${_iconBase}surfbord.png';
  static const String car = '${_iconBase}car.png';
  static const String deletaccount = '${_iconBase}deletaccount.png';
  static const String profile1 = '${_iconBase}person.png';
  static const String star = '${_iconBase}star.png';
  static const String star1 = '${_iconBase}star1.png';
  static const String delete = '${_iconBase}delete.png';
  static const String sendmsg = '${_iconBase}sendmsg.png';
  static const String arrow = '${_iconBase}arrow.png';
  static const String bottomsheetline = '${_iconBase}bottomsheetline.png';

  ///web images
  static const String backgroundimage = '${_authBase}backgrouund.png';
  static const String general = '${_webicons}House.png';
  static const String settings = '${_webicons}settings.png';
  static const String profileUser = '${_webicons}Users.png';
  static const String billing = '${_webicons}billing.png';
  static const String report = '${_webicons}report.png';
}
