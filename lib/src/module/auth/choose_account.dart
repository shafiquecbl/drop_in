import 'package:dropin/src/utils/widgets/pop_scope_dialog.dart';
import 'package:dropin/src_exports.dart';

import '../authprofile/profilescreen_controller.dart';

class ChooseAccount extends StatelessWidget {
  ChooseAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (c) {
          return CustomScaffold(
            body: WillPopScope(
             onWillPop: () async {
               return false;
             },
              child: Center(
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Account Created!\nChoose Your Account Type...'.tr,
                      style: AppThemes.lightTheme.textTheme.headlineLarge
                          ?.copyWith(
                              fontSize: 18, color: AppColors.appWhiteColor),
                    ),
                    AppElevatedButton(
                      width: context.width * 0.90,
                      height: 50,
                      callback: () {
                        Get.toNamed(
                          Routes.CreateProfileScreen,
                          arguments: c.isEditProfile.isTrue,
                        );
                      },
                      title: 'Just Surfing!'.tr,
                    ).paddingSymmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    AppElevatedButton(
                      width: context.width * 0.90,
                      height: 50,
                      callback: () {
                        app.isBusiness = true;
                        Get.toNamed(Routes.AddYourBusiness);
                      },
                      title: 'Business?'.tr,
                    ).paddingSymmetric(horizontal: 20),
                  ],
                ).paddingOnly(top: context.height * 0.35),
              ),
            ),
          );
        });
  }
}
