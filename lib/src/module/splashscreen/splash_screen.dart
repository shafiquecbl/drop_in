import 'package:dropin/src/module/splashscreen/splash_screen_controller.dart';

import '../../../src_exports.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController c = Get.put(SplashScreenController());

  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: CustomScaffold(
        gradient: AppColors.background,
        body: Center(
          child: LoaderView(),
        ),
      ),
    );
  }
}
