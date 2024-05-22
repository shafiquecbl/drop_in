import 'package:dropin/src_exports.dart';
import '../../../src/service/network_service.dart';

class AdminSplashScreenCtrl extends BaseController {
  @override
  void onInit() async {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      authCheck();
    });
    super.onInit();
  }

  void authCheck() async {
    await 2.delay();
    var user = prefs.getValue(key: 'user');
    logger.w(user);
    if (user == null) {
      Get.offAllNamed(Routes.WebLogin);
    } else {
      app.user = UserModel.fromJson(user ?? {});
      net.init(app.user);
      Get.offAllNamed(Routes.NavigationScreen);
    }
  }
}
