import 'package:dropin/web/module/adminsplashscreen/splashscreen_controller.dart';

import '../../../src_exports.dart';

class AdminSplashScreen extends GetResponsiveView {
  final c = Get.put(AdminSplashScreenCtrl());

  AdminSplashScreen({super.key});

  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Center(
        child: LoaderView(color: AppColors.appButtonColor),
      ),
    );
  }

  @override
  Widget tablet() {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: Center(
        child: LoaderView(color: AppColors.appButtonColor),
      ),
    );
  }
}
