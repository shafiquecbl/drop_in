import 'package:dropin/src/module/dropinscreen/dropin_map.dart';
import 'package:dropin/src_exports.dart';

import '../../web/module/adminsplashscreen/admin_splashscreen.dart';
import '../../web/module/profile/bussiness_screen.dart';
import '../../web/module/profile/statistic_screen.dart';
import '../../web/module/profile/user_screen.dart';
import '../module/auth/privacy_policy.dart';
import '../module/dropinscreen/adddropinphotos_screen.dart';
import '../module/newsscreen/location.dart';
import '../module/newsscreen/viewBussiness_screen.dart';
import '../module/newsscreen/viewprofile_screen.dart';
import '../module/profile/business_profile/business_map.dart';
import '../module/profilescreen/addbussiness_screen.dart';
import '../module/profilescreen/editbussiness/detail_screen.dart';
import '../module/profilescreen/editprofile/password.dart';

class Pages {
  static List<GetPage> pages = [
    GetPage(
      name: Routes.LoginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.UpdateBussiness,
      page: () => UpdateBussiness(),
    ),
    GetPage(
      name: Routes.SignUpScreen,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: Routes.ChooseAccount,
      page: () => ChooseAccount(),
    ),
    GetPage(
      name: Routes.CreateProfileScreen,
      page: () => CreateProfileScreen(),
    ),
    GetPage(
      name: Routes.DetailScreen,
      page: () => DetailScreen(),
    ),
    GetPage(
      name: Routes.EditProfileScreen,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: Routes.AddYourBusiness,
      page: () => AddYourBusiness(),
    ),
    GetPage(
      name: Routes.BusinessFinalSetup,
      page: () => BusinessFinalSetup(),
    ),
    GetPage(
      name: Routes.BusinessAddPhotos,
      page: () => BusinessAddPhotos(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => PrivacyPolicy(),
    ),
    GetPage(
      name: Routes.AddPhotos,
      page: () => AddPhotos(),
    ),
    GetPage(
      name: Routes.HomeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: Routes.ProfileEditScreen,
      page: () => ProfileEditScreen(),
    ),
    GetPage(
      name: Routes.DropInMap,
      page: () => DropInMap(),
    ),
    GetPage(
      name: Routes.AddDropinPhotos,
      page: () => AddDropinPhotos(),
    ),
    GetPage(
      name: Routes.ViewBussinessScreen,
      page: () => ViewBussinessScreen(),
    ),
    GetPage(
      name: Routes.EditBio,
      page: () => EditBio(),
    ),
    GetPage(
      name: Routes.ViewProfile,
      page: () => ViewProfile(),
    ),
    GetPage(
      name: Routes.InBoxScreen,
      page: () => InBoxScreen(),
    ),
    GetPage(
      name: Routes.SplashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.ForgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(
      name: Routes.EditBussinessProfile,
      page: () => EditBussinessProfile(),
    ),
    GetPage(
      name: Routes.EditPasswordScreen,
      page: () => EditPasswordScreen(),
    ),
    GetPage(
      name: Routes.LocationMap,
      page: () => LocationMap(),
    ),
    GetPage(
      name: Routes.DropInScreen,
      page: () => DropInScreen(),
    ),
    GetPage(
      name: Routes.BusinessMaps,
      page: () => BusinessMaps(),
    ),
    GetPage(
      name: Routes.SearchScreen,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: Routes.ConformPassword,
      page: () => ConformPassword(),
    ),
    GetPage(
      name: Routes.AddBusiness,
      page: () => AddBusiness(),
    ),
    // GetPage(
    //   name: Routes.BusinessPhotos,
    //   page: () => BusinessPhotos(),
    // ),

    ///admin
  ];

  static List<GetPage> adminPages = [
    GetPage(
      name: Routes.WebLogin,
      page: () => WebLogin(),
      middlewares: [
        LoginMiddleware(),
      ],
    ),
    GetPage(
      name: Routes.NavigationScreen,
      page: () => NavigationScreen(),
      middlewares: <GetMiddleware>[
        HomeMiddleWares(),
      ],
    ),
    GetPage(
      name: Routes.UserScreen,
      page: () => UserScreen(),
    ),
    GetPage(
      name: Routes.StatisticScreen,
      page: () => StatisticScreen(),
    ),
    GetPage(
      name: Routes.BussinessScreen,
      page: () => BussinessScreen(),
    ),
    GetPage(
      name: Routes.AdminSplashScreen,
      page: () => AdminSplashScreen(),
    ),
  ];
}

class HomeMiddleWares extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (app.user.apikey.isEmpty) {
      return const RouteSettings(name: Routes.WebLogin);
    }
    return null;
  }
}

class LoginMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    logger.w(app.user.toJson());
    if (app.user.apikey.isNotEmpty) {
      return const RouteSettings(name: Routes.NavigationScreen);
    }
    return null;
  }
}
