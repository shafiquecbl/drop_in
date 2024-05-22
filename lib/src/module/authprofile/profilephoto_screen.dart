import 'package:dropin/src/module/authprofile/profilescreen_controller.dart';
import 'package:dropin/src/utils/widgets/app_images.dart';

import '../../../src_exports.dart';

class EditProfileScreen extends StatelessWidget {
  final ProfileController c = Get.find<ProfileController>();
  bool isEditProfile = (Get.arguments ?? false);

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      gradient: isEditProfile
          ? AppColors.background
          : AppColors.backgroundTransperent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.transparent,
        title: Text(
          'Profile Photo',
          style: AppThemes.lightTheme.textTheme.headlineMedium?.copyWith(
            fontSize: 25,
            color: AppColors.appWhiteColor,
          ),
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (c) {
          return Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 25,
                    ),
                    child: c.isEditProfile.isFalse
                        ? SizedBox(
                            height: context.height * 0.55,
                            width: context.width,
                            child: ColoredBox(
                              color: Color(0xFFD9D9D9),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Obx(() {
                                  if (c.pickedPath.isEmpty &&
                                      c.isEditProfile.isFalse) {
                                    return CircleAvatar(
                                      backgroundColor: AppColors.appWhiteColor,
                                      radius: 60,
                                      backgroundImage: AppImages.asProvider(
                                        app.user.imageUrl,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      clipBehavior: Clip.hardEdge,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: AppAssets.asFile(
                                        File(c.pickedPath()),
                                        height: context.height * 0.55,
                                        width: context.width,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                }),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                  Positioned(
                    height: 50,
                    right: 20,
                    child: InkWell(
                      splashColor: AppColors.transparent,
                      focusColor: AppColors.transparent,
                      hoverColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onTap: () {
                        c.imagePicker(isProfile: true);
                      },
                      child: AppAssets.asImage(AppAssets.gallary),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: context.height * 0.1,
              ),
              AppElevatedButton(
                width: context.width * 0.90,
                height: 50,
                callback: () async {
                  if (!isEditProfile) {
                    c.navigate1();
                  } else {
                    await c.profilephoto();
                    c.update();
                    app.update();
                  }
                },
                title: isEditProfile ? 'Update' : 'Continue',
              ).paddingSymmetric(horizontal: 20, vertical: 5),
              AppElevatedButton(
                width: context.width * 0.90,
                height: 50,
                callback: () {
                  Get.back();
                },
                title: 'Back',
              ).paddingSymmetric(horizontal: 20, vertical: 5),
            ],
          );
        },
      ),
    );
  }
}
